import boto3
import json

s3_raw_path = "s3://cognitivo-test/raw/users/load.csv"
options_dict = {
    "header": "true",
    "sep": ",",
    "encoding": "latin1",
}


def ddl_schema():
    s3 = boto3.resource('s3')
    obj = s3.Object("cognitivo-test", "raw/users/schema/types_mapping.json")
    json_schema = json.load(obj.get()['Body'])

    ddl = ''
    for column, type in json_schema.items():
        ddl += "{} {}, ".format(str(column), str(type))

    return ddl[:-2]


schema = ddl_schema()

df = (
    spark.read
        .format('csv')
        .options(**options_dict)
        .schema(schema)
        .load(s3_raw_path)
)

df = (
    df.orderBy('update_date', ascending=False)
        .coalesce(1)
        .dropDuplicates(subset=['id'])
).write.mode("overwrite").format("parquet").save("s3://cognitivo-test/staging/users/")