#! /usr/bin/python

import xml.etree.ElementTree as ET
import re
import csv

tree = ET.parse("NZBC-CAS3v4(text).xml")
root = tree.getroot()

def convert_string_to_lower_camel_case(text):
    word_list = text.split()
    final_word=""
    for i, word in enumerate(word_list):
        if i==0:
            final_word += word.lower()
        else:
            final_word += word.capitalize()
    return final_word

definition_list= []

for term in root.iter('term'):
    atom_list=[]
    for elem in term.iter():
        if elem.tag == 'atom':
            atom =  (elem.text).encode("UTF-8")
            key =  (convert_string_to_lower_camel_case(re.sub('[-()]', '', elem.text))).encode("UTF-8")
            atom_list.append(atom)
            atom_list.append(key)
        elif elem.tag == 'description':
            description_string=""
            comment_string = ""
            for child_elem in elem.iter():
                if child_elem.tag == 'commentary':
                    comment_string += child_elem.text + " "
                    for baby_elem in child_elem.iter():
                        if baby_elem.tag =='ol':
                            pass
                        elif baby_elem.tag == 'p':
                            comment_string += baby_elem.text + " "
                        elif baby_elem.tag == 'li':
                            comment_string += (baby_elem.attrib['key'] if 'key' in baby_elem.attrib else baby_elem.attrib['title']) + baby_elem.text + " "
                    break
                elif child_elem.tag =='p':
                    description_string += child_elem.text + " " 
                elif child_elem.tag == 'ol':
                    pass
                elif child_elem.tag == 'li':
                    description_string += (child_elem.attrib['key'] if 'key' in child_elem.attrib else child_elem.attrib['title']) + child_elem.text + " "
            description_string = description_string.strip().rstrip().encode("UTF-8")
            comment_string = comment_string.strip().rstrip().encode("UTF-8")
            atom_list.append(description_string)
            atom_list.append(comment_string)
    definition_list.append(atom_list)


with open ('NZBC-CAS3v4(text).csv', 'wb') as csvfile:
    wr = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
    wr.writerows(definition_list)
