
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
        '    <td><img src=img/banner_x.png /></td> \n' + \
        '  </tr>\n' + \
        '</table>\n\n')

  print("<table bgcolor=whitesmoke width=" + str(pWidth) + " cellpadding=0 >")
  print("<tr><td>&nbsp;</td></tr>")

  string = \
"""\
PGSQL is the PostgreSQL Community Distribution that is developer friendly and cross-platform.
We fully embrace core PostgreSQL and it's rich community based eco-system of
enterprise-class extensions.
<p>
For releases through pg13, we support EL7+ as well as Ubuntu 16.04+.  Starting
with pg14, we only support EL8 (Redhat/Rocky/CentOS) & Ubuntu 20.04+.  We are built with
optimized and secure static binaries that also run on several other Linux flavors (your mileage may vary).
\
"""
  print("  <tr><td colspan=2><h2>Introduction</h2></td></tr>")
  print("  <tr><td colspan=2>\n" + string + "<br>&nbsp;\n" + \
        "  </td></tr>")
  print("</table>")

  print("<table bgcolor=white width=" + str(pWidth) + " cellpadding=1 >")
  print("  <tr><td>&nbsp;</td></tr>")

  ##<td><img width=60% src=img/platforms4.png /></td>

  string = \
"""\
<tr><td colspan=2>
<table>
  <tr>
    <td width=275><h2>Download & Usage</h2></td>
    <td>&nbsp;</td>
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
'python3 -c "$(curl -fsSL https://pgsql-io-download.s3.amazonaws.com/REPO/install.py)"' readonly='readonly' />
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
'cd pgsql; ./io install pg13; ./io start; ./io install timescaledb' readonly='readonly' />
    </td>
</tr>
</table>
\
"""
  print(string)


def print_footer(pWidth):
  print('<center><table width=900><tr> \n' + \
        '   <td width=450>&copy; 2021 PGSQL.IO</td> \n' + \
        '   <td width=450 align=right><a href="https://lussier.io">denis@lussier.io</a></td> \n' + \
        '</tr></table></center>')
