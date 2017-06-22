# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2014-2015, Lars Asplund lars.anders.asplund@gmail.com
import os
import definitions
from vunit import VUnit

def generateFilesList(folder):
    listFileName = os.path.join(definitions.PROJECT_PATH, folder, definitions.FILES_LIST_NAME)
    with open(listFileName, "r") as ins:
        array = []
        for line in ins:
            if line[0] == '#':
                continue
            shortline = line.strip('\n')
            # check if item with folder separator,
            # if so then join properly
            stringSplit = shortline.split('/')
            if len(stringSplit) > 1:
                joinedLine = os.path.sep.join(stringSplit)
                # joinedLine = os.path.join(stringSplit[0], stringSplit[1])
            else:
                # stringSpit is a LIST, size 1
                joinedLine = stringSplit[0]
            fullName = os.path.join(definitions.PROJECT_PATH, folder,joinedLine)
            array.append(fullName)
        return array


if __name__ == "__main__":
    print "exec path = " + definitions.ROOT_DIR
    print "project path = " + definitions.PROJECT_PATH
    ipFiles = generateFilesList(definitions.FOLDER_IP)
    sourceFiles = generateFilesList(definitions.FOLDER_SOURCE)
    tbFiles = generateFilesList(definitions.FOLDER_TB)
    listFiles = ipFiles + sourceFiles + tbFiles
    print "all files count = " , len(listFiles)
    ui = VUnit.from_argv()
    lib = ui.add_library("lib")
    lib.add_source_files(listFiles)
    ui.main()
