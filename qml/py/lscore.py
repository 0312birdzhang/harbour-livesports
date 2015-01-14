#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import urllib.request # for making http requests (downloading data)
from html.parser import HTMLParser # for parsing the web page
# see https://docs.python.org/3.0/library/html.parser.html for more info
import xml.etree.cElementTree as ET # for saving the elements into xml
# see https://docs.python.org/3.1/library/xml.etree.elementtree.html for more info

class GamesHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.new_country = False
        self.new_country_name = False
        self.new_league = False
        self.new_league_name = False
        self.new_league_date = False
        self.new_fd = False
        self.new_fh = False
        self.new_fs = False
        self.new_fa = False
        self.var_type = None
        self.in_table = False
        self.current_country = None
        self.output = ET.Element("leagues")

    def handle_starttag(self, tag, attrs): # this handles start tags, like <a>
        if (self.in_table):
            if (tag == 'a' and self.var_type == 'league'):
                if (self.new_country and self.new_league):
                    self.new_country_name = True
                    self.new_country = False
                elif (self.new_league):
                    self.new_league_name = True
                    self.new_league = False
            elif (tag == 'span' and self.var_type == 'league'):
                for name, value in attrs: # attrs are attributes of the tag. for example tag <a class="myclass" href="www.sparta.cz"> has names ['class', 'href'] and values ['myclass', 'www.sparta.cz']. the 'for' loop goes through every element of these lists
                    if name == 'class' and value == 'date':
                        """ League date """
                        self.new_league_date = True
            elif (tag == 'td' and self.var_type == 'league'):
                """
                Main data
                """
                for name, value in attrs:
                    if name == 'class' and value == 'fd':
                        """
                        Time
                        """
                        self.new_fd = True
                    elif name == 'class' and value == 'fh':
                        """
                        Home team
                        """
                        self.new_fh = True
                    elif name == 'class' and value == 'fs':
                        """
                        Score
                        """
                        self.new_fs = True
                    elif name == 'class' and value == 'fa':
                        """
                        Away team
                        """
                        self.new_fa = True
        else:
            if (tag == 'table'):
                for name, value in attrs:
                    if name == 'class' and value == 'league-table':
                        """ Theater info """
                        self.in_table = True
                        self.new_country = True
                        self.new_league = True
                        self.var_type = 'league'

                
    def handle_data(self, data): # this handles data inside of a tag. for example when you have <a>This is a link</a>, then this will handle the "This is the link" part.
        if self.in_table:
            if self.new_country_name:
                self.league = ET.SubElement(self.output, "league")
                self.league_country = ET.SubElement(self.league, "country")
                self.league_country.text = data.strip()
                self.new_country_name = False
            elif self.new_league_name:
                data = data.strip()
                self.league_name = ET.SubElement(self.league, "name")
                self.league_name.text = data
                self.league_games = ET.SubElement(self.league, "games")
                self.league_id = ET.SubElement(self.league, "id")
                self.league_id.text = self.league_country.text+" - "+data
                self.new_league_name = False
            elif self.new_league_date:
                self.league_date = ET.SubElement(self.league, "date")
                self.league_date.text = data.strip()
                self.new_league_date = False
            elif self.new_fd:
                data = data.strip()
                self.game = ET.SubElement(self.league_games, "game")
                self.game_fd = ET.SubElement(self.game, "fd")
                self.game_league = ET.SubElement(self.game, "league")
                self.game_league.text = self.league_id.text
                self.game_fd.text = data
                self.new_fd = False
                self.game_status = ET.SubElement(self.game, "status")
                
                if (data == "Postp."):
                    self.game_status.text = "postponed"
                elif (data == "FT"):
                    self.game_status.text = "ended"
                elif (data == "HT"):
                    self.game_status.text = "live"
                elif (data == "ET"):
                    self.game_status.text = "extratime"
                elif (":" in data):
                    self.game_status.text = "waiting"
                else:
                    self.game_status.text = "live"
            elif self.new_fh:
                self.game_fh = ET.SubElement(self.game, "fh")
                self.game_fh.text = data.strip()
                self.new_fh = False
            elif self.new_fs:
                data = data.strip()
                self.game_fs = ET.SubElement(self.game, "fs")
                self.game_fs.text = data
                self.game_fsh = ET.SubElement(self.game, "fsh")
                self.game_fsa = ET.SubElement(self.game, "fsa")
                self.new_fs = False
            elif self.new_fa:
                self.game_fa = ET.SubElement(self.game, "fa")
                self.game_fa.text = data.strip()
                self.new_fa = False
        
    def handle_endtag(self, tag): # this function is called when an end tag (like </a> ) is encountered
        if (tag == 'table'): # tag is the name of the tag. in this case in encountered a tag </table>
            self.in_table = False # setting the variable to false

def get(sport=None, country=None, league=None, date=None):
    """
    Get the page.
    """
    url = "http://www.livescore.com"
    resource = urllib.request.urlopen(url) # downloads the url
    return resource.read() # returns the url contents
    

def parse(sport=None, country=None, league=None, date=None):
    content = get(sport, country, league, date)
    parser = GamesHTMLParser() # creates new object from the parser class
    parser.feed(str(content)) # inserts the downloaded content in the class
    xmlstring = str(ET.tostring(parser.output, "utf-8").decode("utf-8")) # gets the generated xml
    return xmlstring # returns the xml

if __name__ == '__main__': # this is called only if you run this file as 'python3 lscore.py'
    print(parse()) # shows the result so one can see it
