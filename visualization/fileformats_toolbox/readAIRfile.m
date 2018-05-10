function T = readAIRfile(filename)
fp = fopen(filename,'rb');

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

T=reshape(fread(fp,16,'double'),[4 4]);
fclose(fp);