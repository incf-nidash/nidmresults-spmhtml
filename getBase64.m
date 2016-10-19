
fid = fopen('DesignMatrix.png','rb');
bytes = fread(fid);
fclose(fid);
encoder = org.apache.commons.codec.binary.Base64;
base64string = char(encoder.encode(bytes))';

tpl = spm_file_template(fileparts(mfilename('fullpath')));
tpl = tpl.file('TPL_RES','spm_results.tpl');
tpl = tpl.block('TPL_RES','resftr','resftrs');
tpl = tpl.block('TPL_RES','cursor','cursors');
tpl = tpl.block('TPL_RES','resrow','resrows');

tpl = tpl.var('IMG_X',spm_file(fDesMtx,'filename'));