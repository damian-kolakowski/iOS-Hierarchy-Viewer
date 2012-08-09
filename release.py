import os
import httplib, urllib
import json
import re
import zipfile

print "Building project...."

os.system('./build_fat')

ver_re = re.compile('(\d+\.)?(\d+\.)?(\d+)')

print "Getting recent releases...."

conn = httplib.HTTPSConnection("api.github.com")
conn.request("GET", "/repos/glock45/iOS-Hierarchy-Viewer/downloads")

releases = json.load(conn.getresponse())

max_version = '0.0.0'

for r in releases:
	search_version = ver_re.search(r['name'])
	if search_version:
		search_version = search_version.group()
		if search_version > max_version:
			max_version = search_version
	print r['name'] + '  >>>> ' + search_version

print 'Latest release version: ' + max_version

version_form_src = ver_re.search(open('iOSViewHierarchy/HVDefines.h', 'r').read())

if version_form_src:
	version_form_src = version_form_src.group()
	print 'Your local version: ' + version_form_src
	if max_version >= version_form_src:
		print 'Please increment version number and rebuild before release'
	else:
		print 'Zipping release files...'
		zipFilePath = "Hierarchy Viewer " + version_form_src + ".zip"
		releaseZip = zipfile.ZipFile(zipFilePath, "w" )
		releaseZip.write("build/iOSHierarchyViewer.h", "iOSHierarchyViewer.h", zipfile.ZIP_DEFLATED )
		releaseZip.write("build/libiOSHierarchyViewer_fat.a", "libiOSHierarchyViewer_fat.a", zipfile.ZIP_DEFLATED )
		print '...zipped and ready to upload ('  + zipFilePath + ')'
else:
	print "Can't find version number in 'HVDefines.h' file"
