
def print_header(pWidth):
  print("<title>OpenRDS: Robust Data Services </title>")

  print("<center>")

  print('<table border=0 bgcolor=black cellpadding=0 width=' + str(pWidth) + '>\n' +
        '  <tr> \n' + \
        '    <td><img src=img/openrds-banner1.png /></td> \n' + \
        '  </tr>\n' + \
        '</table>\n\n')

  print("<table bgcolor=whitesmoke width=" + str(pWidth) + " cellpadding=0 >")
  print("<tr><td>&nbsp;</td></tr>")


def print_footer():
  print('<center><table><tr> \n' + \
        '   <td width=550>&copy; 2021 All Rights Reserved.</td> \n' + \
        '   <td width=550 align=right><a href=""></a></td> \n' + \
        '</tr></table></center>')
