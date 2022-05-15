import boto3

def upload_arquivo():
    s3_client = boto3.client('s3')

    files = [
                r"RAIS_VINC_PUB_CENTRO_OESTE.txt",
                r"RAIS_VINC_PUB_MG_ES_RJ.txt",
                r"RAIS_VINC_PUB_NORDESTE.txt",
                r"RAIS_VINC_PUB_NORTE.txt",
                r"RAIS_VINC_PUB_SP.txt",
                r"RAIS_VINC_PUB_SUL.txt"
    ]

    print("Fazendo upload...")
    for i in range(len(files)):
        s3_client.upload_file(files[i],
                              "igti-datalake-atheobaldo",
                              "raw-data/rais/" + files[i])
        print("Finalizado: " + files[i])
    print("Sucesso")
 
upload_arquivo()