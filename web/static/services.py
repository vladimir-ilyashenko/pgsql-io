import sqlite3, sys

NUM_COLS = 3

#ALL_PLATFORMS = "arm, amd"
ALL_PLATFORMS = "amd"
isSHOW_COMP_PLAT = "Y"
isEXTRA_SPACING = "N"
isSHOW_DESCRIPTION = "Y"
HEADING_SIZE = "+1"

BR = "<br>"
WIDTH = 900
COL_SIZE = 600
FONT_SIZE = 3
IMG_SIZE = 35
BORDER=0

# condensed format
if NUM_COLS == 1:
  BR = "&nbsp;"
  FONT_SIZE = 4
  COLS_SIZE = 600
  IMG_SIZE = 35
  BORDER=1

# logo's for slide decks
if NUM_COLS == 2:
  COLS_SIZE = 600
  isSHOW_COMP_PLAT = "N"
  isEXTRA_SPACING = "Y"
  IMG_SIZE = 65
  FONT_SIZE = 6
  HEADING_SIZE = "+3"


def print_top():
  print_header(WIDTH)
  print("\n<p>")
  print('<table width=' + str(WIDTH) + ' border=' + str(BORDER) + ' bgcolor=whitesmoke cellpadding=1>')

 
def print_bottom():
  print('\n</td></tr></table></center><br>\n')
  print_footer()


def get_columns(d):
  global cat, cat_desc, image_file, component, project, release_name
  global version, source_url, project_url, platform, rel_date, rel_month
  global rel_day, rel_yy, stage, proj_desc, rel_desc, pre_reqs, license
  global version, rel_notes

  cat = str(d[0])
  cat_desc = str(d[1])
  image_file = str(d[2])
  component = str(d[3])
  project = str(d[4])
  release_name = str(d[5])
  version = str(d[6]).replace("-1", "")
  source_url = str(d[7])
  project_url = str(d[8])
  license = str(d[15])

  pre_reqs = str(d[14])
  pre_reqs = pre_reqs.lower()
  pre_reqs = pre_reqs.replace('amd64', 'amd')
  pre_reqs = pre_reqs.replace('openjdk', 'jdk')
  

  platform = str(d[9])
  if (platform == ""):
    if pre_reqs > "":
      platform = "[" + pre_reqs + "]"
    else:
      platform = "[" + ALL_PLATFORMS + "]"
  else:
    platform = "[" + platform + "]"

  rel_date = str(d[10])
  rel_yy = rel_date[2:4]
  rel_month = rel_date[4:6]
  if rel_month == "01":
     rel_month = "Jan"
  elif rel_month == "02":
     rel_month = "Feb"
  elif rel_month == "03":
     rel_month = "Mar"
  elif rel_month == "04":
     rel_month = "Apr"
  elif rel_month == "05":
     rel_month = "May"
  elif rel_month == "06":
     rel_month = "Jun"
  elif rel_month == "07":
     rel_month = "Jul"
  elif rel_month == "08":
     rel_month = "Aug"
  elif rel_month == "09":
     rel_month = "Sep"
  elif rel_month == "10":
     rel_month = "Oct"
  elif rel_month == "11":
     rel_month = "Nov"
  elif rel_month == "12":
     rel_month = "Dec"

  rel_day = rel_date[6:]
  if rel_day[0:1] == "0":
    rel_day = rel_day[1]

  stage = ""
  stage = str(d[11])
  if stage in ("prod", "included", "bring-own"):
    stage = ""
  else:
    #if stage == "soon":
    #  stage = "Soon!"
    #  rel_date = "19700101"
    #else:
    stage = "--" + stage
    stage = "<font color=red>" + stage + "</font>"

  proj_desc = str(d[12])
  rel_desc  = str(d[13])
  pre_reqs  = str(d[14])
  license   = str(d[15])

  rel_notes = str(d[18])


def print_row_header(pBR):
  if isEXTRA_SPACING == "Y":
    print("<tr><td>&nbsp;</td></tr>")

  print("<tr><td colspan=" + str(NUM_COLS * 2) + \
    ">&nbsp;<p>&nbsp;<b><font size=" + HEADING_SIZE + ">" + \
    cat_desc + "</font></b></td></tr>")


def print_row_detail(pCol, pBR):
  global proj_desc, rel_desc, component

  platd = ""
  if isSHOW_COMP_PLAT == "Y":
    platd = BR + component + " " + platform + " " + stage

  if str(rel_yy) < "20":
    rel_yy_display = "-" + rel_yy
  else:
    rel_yy_display = ""
    
  if rel_date in ('', '19700101'):
    rel_date_display = ""
  else:
    rel_date_display = rel_day + "-" + rel_month + rel_yy_display
    if rel_notes > "":
      rel_date_display = "<a href=" + rel_notes + ">" + rel_date_display + "</a>"

  if isSHOW_DESCRIPTION == "N" or component[0:3] in ("pg9", "pg1"):
    proj_desc = ""

  if rel_desc > '':
    proj_desc = rel_desc

  print("  <td width=" + str(IMG_SIZE) + ">&nbsp;<img src=img/" + image_file + \
    " height=" + str(IMG_SIZE) + " width=" + str(IMG_SIZE) + " /></td>")
  print("  <td width=" +str( COL_SIZE) + "><font size=" + str(FONT_SIZE) + \
    "><a href=" + project_url + ">" + release_name + \
    "</a>&nbsp;&nbsp;<a href=" + source_url + ">v" + version + \
    "</a>&nbsp;<font color=red size=-1><sup>" + \
    rel_date_display +"</sup></font>" + \
    platd + pBR + "<i>" + proj_desc + "</font></i></td>")

  if pCol == NUM_COLS:
    print("</tr>")
    if isEXTRA_SPACING == "Y":
      print("<tr><td>&nbsp;</td></tr>")
   
    
    if NUM_COLS != 1:
      print("<tr><td></td></tr>")

  return


def print_header(pWidth):
  print("<title>OpenRDS: Robust Data Services </title>")

  print("<center>")

  print('<table border=0 bgcolor=black cellpadding=0 width=' + str(pWidth) + '>\n' +
        '  <tr> \n' + \
        '    <td><img src=img/pgsql-banner6.png /></td> \n' + \
        '  </tr>\n' + \
        '</table>\n\n')

  print("<table bgcolor=whitesmoke width=" + str(pWidth) + " cellpadding=0 >")
  print("<tr><td>&nbsp;</td></tr>")

  string = \
"""\
Database as a Service in the Hybrib & Multi-Cloud.
\
"""
  print("  <tr><td colspan=2><h2>Introduction</h2></td></tr>")
  print("  <tr><td colspan=2>\n" + string + "<br>&nbsp;\n" + \
        "  </td></tr>")
  print("</table>")


def print_footer():
  print('<center><table><tr> \n' + \
        '   <td width=550>&copy; 2021 OPENRDS</td> \n' + \
        '   <td width=550 align=right><a href=""></a></td> \n' + \
        '</tr></table></center>')


##################################################################
#   MAINLINE
##################################################################
con = sqlite3.connect("local.db")
c = con.cursor()

sql = "SELECT cat, cat_desc, image_file, component, project, release_name, \n" + \
      "       version, sources_url, project_url, platform, release_date, \n" + \
      "       stage, proj_desc, rel_desc, pre_reqs, license, cat_sort, \n" + \
      "       rel_sort, release_notes \n" + \
      "  FROM v_versions v, services s \n" + \
      " WHERE v.project = s.service \n" + \
      "   AND is_current >= 1 AND component NOT IN ('pg10') \n" + \
      "ORDER BY 17, 18"

c.execute(sql)
data = c.fetchall()

i = 0
old_cat_desc = ""
print_top()
col = 0
skip_next = False

for d in data:
  if i == 0:
    old_d = d
    i = 1
    continue

  if skip_next == True:
    old_d = d
    skip_next = False
    continue

  i = i + 1
  
  get_columns(old_d)

  next_comp = str(d[3])                                                         
  next_proj = str(d[4])
  next_rel  = str(d[5])                                                         
  next_ver  = str(d[6]).replace("-1", "")

  ## break processing
  if ((next_proj == project) and 
      (next_rel == release_name) and 
      (next_ver == version)):
    skip_next = True
    component = component + "," + next_comp[-2:]

  if (old_cat_desc != cat_desc):
    print_row_header(BR)
    col = 1

  if col == 1:
    print("<tr>")

  print_row_detail(col, BR)

  if col == NUM_COLS:
    col = 1
  else:
    col = col + 1

  old_cat_desc = cat_desc
  old_d = d

#last row
get_columns(d)
print_row_detail(col, BR)

print_bottom()
sys.exit(0)
