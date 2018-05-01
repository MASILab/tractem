function writeAIRfile(filename, T)
fp = fopen(filename,'wb');

% #define AIR_CONFIG_MAX_PATH_LENGTH 128			/* Default is 128--changing this value makes .air and .warp files */
% #define AIR_CONFIG_MAX_COMMENT_LENGTH 128		/* incompatible with versions that use the default		  */
% #define AIR_CONFIG_RESERVED_LENGTH 116			/* Default is 116 */
% 
% struct AIR_Air16{
% 	double  			e[4][4];
% 	char    			s_file[AIR_CONFIG_MAX_PATH_LENGTH];
% 	struct AIR_Key_info	s;
% 	char    			r_file[AIR_CONFIG_MAX_PATH_LENGTH];
% 	struct AIR_Key_info	r;
% 	char    			comment[AIR_CONFIG_MAX_COMMENT_LENGTH];
% 	unsigned long int	s_hash;
% 	unsigned long int	r_hash;
% 	unsigned short		s_volume;	/* Not used in this version of AIR */
% 	unsigned short		r_volume;	/* Not used in this version of AIR */
% 	char				reserved[AIR_CONFIG_RESERVED_LENGTH];
% };
N=0;
N=N+fwrite(fp,T(:),'double')*8;
comment = uint8('Dummy/s_file');
comment((end+1):128)=0;
N=N+fwrite(fp,comment,'uint8')*1;
N=N+writeISOKeyInfo(fp);
%%%%%%%%%%%%%%%%%%
comment = uint8('Dummy/r_file');
comment((end+1):128)=0;
N=N+fwrite(fp,comment,'uint8')*1;
N=N+writeISOKeyInfo(fp);
%%%%%%%%%%%%%%%%%%
comment = uint8('Dummy/comment');
comment((end+1):128)=0;
N=N+fwrite(fp,comment,'uint8')*1;
zero=0;
N=N+fwrite(fp,zero,'uint32')*4;
N=N+fwrite(fp,zero,'uint32')*4;
N=N+fwrite(fp,zero,'uint16')*2;
N=N+fwrite(fp,zero,'uint16')*2;
comment=[];comment(1:116)=0;
N=N+fwrite(fp,comment,'uint8')*1;
fclose(fp);

function N= writeISOKeyInfo(fp)
% struct AIR_Key_info{
%         unsigned int bits;
%         unsigned int x_dim;
%         unsigned int y_dim;
%         unsigned int z_dim;
%         double x_size;
%         double y_size;
%         double z_size;
% };
N=0;
N=N+fwrite(fp,[8 100 100 100],'uint32')*4;
N=N+fwrite(fp,[1 1 1],'double')*8;
