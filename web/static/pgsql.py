
def print_header(pWidth):
  print("<title>PGSQL: PostgreSQL Community Distribution </title>")

  print( \
""" \n \
<!-- Start Alexa Certify Javascript -->
<script type="text/javascript">
_atrk_opts = { atrk_acct:"D/nDv1DlQy20Y8", domain:"pgsql.io",dynamic: true};
(function() { var as = document.createElement('script'); as.type = 'text/javascript'; as.async = true; as.src = "https://certify-js.alexametrics.com/atrk.js"; var s = document.getElementsByTagName('script')[0];s.parentNode.insertBefore(as, s); })();
</script>
<noscript><img src="https://certify.alexametrics.com/atrk.gif?account=D/nDv1DlQy20Y8" style="display:none" height="1" width="1" alt="" /></noscript>
<!-- End Alexa Certify Javascript -->  
\
""")

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
PGSQL is the PostgreSQL Community Distribution that is developer friendly and cross-platform.
We fully embrace core PostgreSQL and it's rich community based eco-system of
enterprise-class extensions & applications.
We support Ubuntu & CentOS on both AMD64 & ARM64 (including on Windows 10 Subsystem for Linux)
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
From PostgreSQL 12 and on we are verified & tested, on x86_64 & arm64, with Python 3; 
CentOS 8-stream; Ubuntu 20.04 LTS; and Windows 10 Subsytem for Linux.
We run in a sandboxed environment that is perfect for running
in a container, on bare metal, or in the multi-cloud environment
of your choice.

<br>&nbsp;</td></tr>
<tr><td width=240 align=right><b>Install as non-root user:</b></td>
  <td><input type='text' size=90 value =
'cd $HOME; python3 -c "$(curl -fsSL https://pgsql-io-download.s3.amazonaws.com/REPO/install.py)"' readonly='readonly' />
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
'cd pgsql; ./io install pg12; ./io start pg12; ./io install timescale' readonly='readonly' />
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
