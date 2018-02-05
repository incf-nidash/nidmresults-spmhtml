<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
                "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head>
  <title>{SPM}: {CON_TITLE}</title>
  <meta name="description" content="{CON_TITLE}">
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <meta name="generator" content="{SPM} &copy; 1991, 1994-{YEAR} Wellcome Trust Centre for NeuroImaging">
  <!-- <link type="text/css" rel="stylesheet" href="spm.css"> -->
  <style type="text/css">
    .crisp {
      image-rendering: -moz-crisp-edges;         /* Firefox */
      image-rendering:   -o-crisp-edges;         /* Opera */
      image-rendering: -webkit-optimize-contrast;/* Webkit (non-standard naming) */
      image-rendering: crisp-edges;
      -ms-interpolation-mode: nearest-neighbor;  /* IE (non-standard property) */
    }
    .body {
      margin-bottom: 50px;
    }
    .footer {
        background: white;
        position: fixed;
        left: 0;
        right: 0;
        bottom: 0;
        font-size: 0.9em;
    }    
  </style>
  <script type="text/javascript">
    function moveto(x,y,z) {
      P1 = 125; P2 = 269; P3 = 105; P4 = 307;
      document.getElementById('cs1').style.left = P1+y+'px';
      document.getElementById('cs1').style.top  = P2+x+'px';
      document.getElementById('cs2').style.left = P1+y+'px';
      document.getElementById('cs2').style.top  = P3-z+'px';
      document.getElementById('cs3').style.left = P4+x+'px';
      document.getElementById('cs3').style.top  = P3-z+'px';
    }
  </script>
</head>

<div class="body">

<!--<h1 style="text-align:center;">{CON_TITLE}</h1>-->

<table style="width:615px;">
  <tr>
    <td colspan="2" align="center"><h1 style="text-align:center;">{CON_TITLE}</h1></td>
  </tr>
  <tr>
    <td><div style="position:relative;">
      <img src="{IMG_MIP}" class="crisp"/>
      <!-- BEGIN cursor -->
      <img id="{CS_ID}" src="{IMG_CURSOR}" class="crisp" width="8" height="11" style="position:absolute;top:{CS_Y}px;left:{s}px"/>
      <!-- END cursor -->
      <div style="position:absolute;top:225px;left:240px;font-size:x-large;font-weight:bold;">{SOFTWARE}&#123{STAT_STR}&#125</div>
    </div></td>
    <td>
      <table>
        <tr><td>
          <img src="{IMG_CON}" class="crisp" width="200" height="30" border="1" style="position:relative;bottom:2px;"/>
        </td></tr>
        <tr><td>
          <img src="{IMG_X}" class="crisp" width="200" height="300" border="1"/>
        </td></tr>
      </table>
    </td>
  </tr>
</table>

<!--<p><strong>Statistics: <em>{RES_TITLE}</em></strong></p>-->
<table border="0" style="width:615px; table-layout: auto;">
  <tr>
    <td colspan="{TABWID}" style="border-bottom: 5px solid #F00;"><strong>Statistics: <em>{RES_TITLE}</em></strong></td>
  </tr>
  <tr>
   {SECTHEAD}
  </tr>
  <tr>
    {CHSTR}  
  </tr>
  <tr>
    <td colspan="{TABWID}" style="border-bottom: 2px solid #F00;"><span style="font-size:1px;">&nbsp;</span></td>
  </tr>
  <!-- BEGIN resrow -->
  <tr>
    {ROWSTR}
    <td align="center"><div onmouseover="moveto({RES_XYZ});this.style.fontWeight='bold';" onmouseout="this.style.fontWeight='normal';">{RES_COLEND}</div></td></tr>
  </tr>
  <!-- END resrow -->
</table>

</div>

<div class="footer">
<hr/>
<p><em>{RES_STR}</em></p>
<table>
  <!-- BEGIN resftr -->
  <tr><td>{RES_FTR_1}</td><td>{RES_FTR_2}</td></tr>
  <!-- END resftr -->
</table>

<hr/><address> {NIDMVERSION} Generated on {DATE} by <strong><a href="http://www.fil.ion.ucl.ac.uk/spm/">{SPM}</a></strong> &copy; 1991, 1994-{YEAR} Wellcome Trust Centre for NeuroImaging</address>
</div>

</html>
