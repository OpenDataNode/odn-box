'''
This script takes .po files for each localization from INSTALLED extensions and
first merges it with INSTALLED ckan .po file and compiles it. After this script is run
the application server needs to be restarted.

The extension need to have the localization in path:
{CKANEXT_EGG_PATH}/ckanext/i18n/{LOCALE}/LC_MESSAGES/*.po
this .po files can be generated through babel module
the {LOCALE} should be the localization string e.g. 'fr'

!!!!!!!!!!!!
This script MUST be run under virtualenv activated where the extension and ckan are installed
!!!!!!!!!!!!

Created on 26.1.2015

@author: mvi
'''
import pip
import os

extension_string = 'ckanext-odn-'  # the odn extension identification string
i18n_dir = 'ckanext/i18n'  # the dir where the localizations are in the extension
ckan_i18n_path = '{CKAN_PATH}/ckan/i18n'
template_locale_path = '{PATH}/{locale}/LC_MESSAGES/{po_file}'


def find_po_files(path, to_merge_localizations):
    dir = os.path.join(path, i18n_dir)

    if os.path.exists(dir):
        locale_dirs = next(os.walk(dir))[1]
        for locale in locale_dirs:
            localization = create_localization(locale, dir)

            if locale in to_merge_localizations:
                to_merge_localizations[locale] = to_merge_localizations[locale] + localization.po_paths
            else:
                to_merge_localizations[locale] = localization.po_paths


def create_localization(locale, parent_dir):
    dir = template_locale_path.format(PATH=parent_dir, locale=locale, po_file='')
    po_files = []

    if os.path.exists(dir):
        names = os.listdir(dir)
        for name in names:
            fname_path = os.path.join(dir, name)
            fext = os.path.splitext(fname_path)[1]
            if fext == '.po':
                po_files.append(fname_path)

    localization = Localization(locale, po_files)
    return localization


def merge_and_compile(ckan_po, ckan_mo, po_files):
    if not os.path.exists(ckan_po):
        raise Exception('ckan_po doesnt exist: {0}'.format(ckan_po))
    if not os.path.exists(ckan_mo):
        raise Exception('ckan .mo doesnt exist: {0}'.format(ckan_mo))

    for po_file in po_files:
        if not os.path.exists(ckan_mo):
            raise Exception('.po file doesnt exist: {0}'.format(po_file))

        print 'processing: {0}'.format(po_file)

        merge_cmd = 'msgcat --use-first {0} {1} -o {1}'.format(po_file, ckan_po)
        if os.system(merge_cmd) == 0:
            print 'merging OK'
        else:
            print 'ERROR: merging FAILED'
            return

        compile_cmd = 'msgfmt -f {0} -o {1}'.format(ckan_po, ckan_mo)
        if os.system(compile_cmd) == 0:
            print 'compiling OK'
        else:
            print 'ERROR: compiling FAILED'


def install_localization(ckan_path, to_merge_localizations):
    for locale in to_merge_localizations.keys():
        ckan_po = template_locale_path.format(PATH=ckan_path, locale=locale, po_file='ckan.po')
        ckan_mo = template_locale_path.format(PATH=ckan_path, locale=locale, po_file='ckan.mo')
        locals_po = to_merge_localizations[locale]

        print 'merge and compile for locale = {0}'.format(locale)
        merge_and_compile(ckan_po, ckan_mo, locals_po)


class Localization():
    def __init__(self, localization, po_paths=None):
        self.locale_str = localization
        self.po_paths = po_paths

    def __str__(self):
        return "locale={0}:{1}".format(self.locale_str, self.po_paths)

    def __repr__(self):
        return self.__str__()


if __name__ == '__main__':
    ckan_i18n_paths = []
    to_merge_localizations = {}

    for distr in pip.get_installed_distributions():
        path = distr.location
        version = distr.version
        name = distr.key

        if extension_string in name:
            find_po_files(path, to_merge_localizations)
            print 'odn ckanext found: {0} : {1}'.format(name, version)

        if 'ckan' == name:
            ckan_i18n_paths.append(ckan_i18n_path.format(CKAN_PATH=path))
            print 'CKAN found: {0} : {1}'.format(name, version)

    if len(to_merge_localizations) == 0:
        print "No extension found starting '{0}'".format(extension_string)
    elif len(ckan_i18n_paths) == 0:
        print "No CKAN found"
    else:
        for ckan_path in ckan_i18n_paths:
            install_localization(ckan_path, to_merge_localizations)
