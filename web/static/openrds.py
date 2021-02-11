
def print_header(pWidth):
  print("<title>OpenRDS: Robust Data Services in the Hybrib and Multi-Cloud</title>")

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
Open Robust Data Services
\
"""
  print("  <tr><td colspan=2><h2>Introduction</h2></td></tr>")
  print("  <tr><td colspan=2>\n" + string + "<br>&nbsp;\n" + \
        "  </td></tr>")
  print("</table>")

  print("<table bgcolor=white width=" + str(pWidth) + " cellpadding=1 >")
  print("  <tr><td>&nbsp;</td></tr>")

  string = \
"""\
<tr><td colspan=2>
<table>
  <tr>
    <td width=275><h2>Download & Usage</h2></td>
    <td><img width=60% src=img/platforms4.png /></td>
  </tr>
</table>
</td></tr>

<tr><td colspan=2>
We run in a sandboxed environment that is perfect for running
in a container, on bare metal, or in the cloud environment
of your choice.

<br>&nbsp;</td></tr>
<tr><td width=240 align=right><b>Install as non-root user:</b></td>
  <td><input type='text' size=90 value =
'python3 -c "$(curl -fsSL https://openrds-download.s3.amazonaws.com/REPO/install.py)"' readonly='readonly' />
  </td>
</tr>
\
"""
  print(string)

  string = \
"""\
<tr><td>&nbsp;</td></tr>
<tr><td align=right><p><b>Usage sample:</b></td>
    <td>
      <input type='text' size=90 value =
'cd openrds; ./io install pg12 --autostart' readonly='readonly' />
    </td>
</tr>
</table>
\
"""
  print(string)


def print_footer():
  print('<center><table><tr> \n' + \
        '   <td width=550>&copy; 2021 PGSQL.IO</td> \n' + \
        '   <td width=550 align=right><a href="https://lussier.io">denis@lussier.io</a></td> \n' + \
        '</tr></table></center>')
