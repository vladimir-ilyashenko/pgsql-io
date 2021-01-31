
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
