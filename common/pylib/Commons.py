import json
import os
from json import load
from datetime import datetime
from robot.api.deco import keyword
import PyPDF2 
# from DynamicTestLibrary import  add_test_case
# THIS_DIR = dirname(abspath(__file__))
# PDFTOTEXT = join(THIS_DIR, 'xpdf', 'pdftotext.exe')
# NOTE: How to locate elements?
# https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Locating%20elements


class AttrDict(dict):
    # box => dot
    # foo["item"] => foo.item
    def __getattr__(self, name):
        val = self[name]
        if isinstance(val, dict):
            return AttrDict(**val)
        return val


class PageObject:
    def __init__(self, locators_dir, filename):
        self.filepath = f"{locators_dir}/{filename}"
        with open(self.filepath) as _locators_file:
            locators = load(_locators_file)
            self.locators = AttrDict(**locators)

    def __getattr__(self, name):
        if name not in self.locators:
            raise Exception(f"locator '{name}' not found in '{self.filepath}'")
        return getattr(self.locators, name)



@keyword
def get_page_object(locators_dir, filename):
    return PageObject(locators_dir=locators_dir, filename=filename)


def __removechar__(char,index):
    index=int(index)
    str= char[:index]
    return str

@keyword
def remove_character(char, index):
    return __removechar__(char=char, index=index)

def __pdf_to_text__(path):
    pdfFileObj = open('{}'.format(path), 'rb')  
    pdfReader = PyPDF2.PdfFileReader(pdfFileObj) 
    numOfPages = pdfReader.getNumPages()
    print(numOfPages)
    # list_for_pdf = []
    var =''
    for i in range(0, numOfPages):
        pageObj = pdfReader.getPage(i)
        textdata= pageObj.extractText()
        var += textdata
    return  var

@keyword
def pdf_to_text(path):
    return __pdf_to_text__(path=path)


