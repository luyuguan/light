#include <stdio.h> 
#include <stdlib.h>

const char* mono_post_process_key = "zheshiwomendeyouxi";

void mono_data_process(char* data, int len)
{
	int j;

	for(j = 0;j < 32;j++)
	{
		data[j] += mono_post_process_key[j%18];
	}
}


void mono_data_jiami(char* data, int len)
{
	int j;

	for(j = 0;j < 32;j++)
	{
		data[j] -= mono_post_process_key[j%18];
	}
}

int main(int argc, char** argv)
{
	printf("start process\n");
	char* param = argv[1];
	char* file = argv[2];
	char* fileOut = argv[3];
	printf("param:%s\n", param);
	printf("file:%s\n", file);
	printf("file out:%s\n", fileOut);

	FILE *fp =fopen(file,"rb");
    fseek(fp, 0, SEEK_END);  
  	long siz = ftell(fp);

	printf("input lenght:%d\n", (int)siz);

    unsigned char* bytebuf = (unsigned char*)malloc(siz);  
    fseek(fp, 0, SEEK_SET);  
    fread(bytebuf, 1, siz, fp);

	if(param[0] == 'e')
	{
		mono_data_jiami((char*)bytebuf, siz);
	}
	else if(param[0] == 'd')
	{
		mono_data_process((char*)bytebuf, siz);
	}

	FILE *fpOut =fopen(fileOut,"wb");
	fwrite(bytebuf, 1, siz, fpOut);

	free(bytebuf);
	fclose(fp);
	fflush(fpOut);
	fclose(fpOut);
	return 0;
}
