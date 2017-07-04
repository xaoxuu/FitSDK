

////////////////////////////////////////////////////////////////////////////////
// The following FIT Protocol software provided may be used with FIT protocol
// devices only and remains the copyrighted property of Dynastream Innovations Inc.
// The software is being provided on an "as-is" basis and as an accommodation,
// and therefore all warranties, representations, or guarantees of any kind
// (whether express, implied or statutory) including, without limitation,
// warranties of merchantability, non-infringement, or fitness for a particular
// purpose, are specifically disclaimed.
//
// Copyright 2008-2015 Dynastream Innovations Inc.
////////////////////////////////////////////////////////////////////////////////

#define _CRT_SECURE_NO_WARNINGS

#include "stdio.h"
#include "string.h"

#include "fit_product.h"
#include "fit_crc.h"

///////////////////////////////////////////////////////////////////////
// Private Function Prototypes
///////////////////////////////////////////////////////////////////////

void WriteFileHeader(FILE *fp);
///////////////////////////////////////////////////////////////////////
// Creates a FIT file. Puts a place-holder for the file header on top of the file.
///////////////////////////////////////////////////////////////////////

void WriteMessageDefinition(FIT_UINT8 local_mesg_number, const void *mesg_def_pointer, FIT_UINT8 mesg_def_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends a FIT message definition (including the definition header) to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteMessageDefinitionWithDevFields
(
 FIT_UINT8 local_mesg_number,
 const void *mesg_def_pointer,
 FIT_UINT8 mesg_def_size,
 FIT_UINT8 number_dev_fields,
 FIT_DEV_FIELD_DEF *dev_field_definitions,
 FILE *fp
 );
///////////////////////////////////////////////////////////////////////
// Appends a FIT message definition (including the definition header)
// and additionalo dev field definition data to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteMessage(FIT_UINT8 local_mesg_number, const void *mesg_pointer, FIT_UINT8 mesg_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends a FIT message (including the message header) to the end of a file.
///////////////////////////////////////////////////////////////////////

void WriteDeveloperField(const void* data, FIT_UINT8 data_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Appends Developer Fields to a Message
///////////////////////////////////////////////////////////////////////

void WriteData(const void *data, FIT_UINT8 data_size, FILE *fp);
///////////////////////////////////////////////////////////////////////
// Writes data to the file and updates the data CRC.
///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
// Private Variables
///////////////////////////////////////////////////////////////////////

static FIT_UINT16 data_crc;

int createTestFit(const char *path)
{
    FILE *fp;
    
    data_crc = 0;
    
    fp = fopen(path, "w+b");
    printf("%s", path);
    
    WriteFileHeader(fp);
    
    // Write file id message.
    {
        FIT_UINT8 local_mesg_number = 0;
        FIT_FILE_ID_MESG file_id;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_FILE_ID], &file_id);
        
        // @xaoxuu: type FIT_FILE_ACTIVITY = 4 活动数据
        file_id.type = FIT_FILE_ACTIVITY;
        // @xaoxuu: 厂商
        file_id.manufacturer = FIT_MANUFACTURER_GARMIN;
        // @xaoxuu: 产品
        //        file_id.product_name
        file_id.product = 0;
        // @xaoxuu: 序列号
        file_id.serial_number = 3870143719;
        // @xaoxuu: 生产日期
        //        file_id.time_created
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FILE_ID], FIT_FILE_ID_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &file_id, FIT_FILE_ID_MESG_SIZE, fp);
    }
    
    
    // Write a Field Description
    {
        FIT_UINT8 local_mesg_number = 1;
        FIT_FIELD_DESCRIPTION_MESG field_description_mesg;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_FIELD_DESCRIPTION], &field_description_mesg);
        field_description_mesg.developer_data_index = 0;
        field_description_mesg.field_definition_number = 0;
        field_description_mesg.fit_base_type_id = FIT_BASE_TYPE_UINT16;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FIELD_DESCRIPTION], FIT_FIELD_DESCRIPTION_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &field_description_mesg, FIT_FIELD_DESCRIPTION_MESG_SIZE, fp);
    }
    
    //Record Defenition
    
    {
        FIT_UINT8 local_mesg_number = 2;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_RECORD],
                               FIT_RECORD_MESG_DEF_SIZE, fp);
    }
    
    //Record message
    {
        FIT_UINT8 local_mesg_number = 2;
        FIT_RECORD_MESG record;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_RECORD], &record);
        record.timestamp = 702940946;
        record.position_lat = 495280430;
        record.position_long = -872696681;
        record.distance = 2;
        record.altitude = 278.2;
        record.speed = 0.29;
        record.heart_rate = 68;
        
        WriteMessage(local_mesg_number,&record,FIT_RECORD_MESG_SIZE,fp);
    }
    
    //Session message
    {
        FIT_UINT8 local_mesg_number = 3;
        FIT_SESSION_MESG session;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_SESSION], &session);
        session.sport = FIT_SPORT_RUNNING;
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_SESSION],
                               FIT_SESSION_MESG_DEF_SIZE, fp); //所有字段定义过长，正尝试如何裁剪
        WriteMessage(local_mesg_number, &session, FIT_SESSION_MESG_SIZE, fp);
        
    }
    
    //Activity message
    {
        FIT_UINT8 local_mesg_number = 4;
        FIT_ACTIVITY_MESG activity;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_ACTIVITY], &activity);
        activity.num_sessions = 1;
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_ACTIVITY],
                               FIT_ACTIVITY_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &activity, FIT_ACTIVITY_MESG_SIZE, fp);
        
    }
    
    
    
    // Write CRC.
    fwrite(&data_crc, 1, sizeof(FIT_UINT16), fp);
    
    // Update file header with data size.
    WriteFileHeader(fp);
    
    fclose(fp);
    
    return 0;
}

FILE *fit_start_transaction(const char *path){
    FILE *fp;
    
    data_crc = 0;
    
    fp = fopen(path, "w+b");
    printf("%s", path);
    
    WriteFileHeader(fp);
    
    // Write file id message.
    {
        FIT_UINT8 local_mesg_number = 0;
        FIT_FILE_ID_MESG file_id;
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_FILE_ID], &file_id);
        
        // @xaoxuu: type FIT_FILE_ACTIVITY = 4 活动数据
        file_id.type = FIT_FILE_ACTIVITY;
        // @xaoxuu: 厂商
        file_id.manufacturer = FIT_MANUFACTURER_GARMIN;
        // @xaoxuu: 产品
        //        file_id.product_name
        file_id.product = 0;
        // @xaoxuu: 序列号
        file_id.serial_number = 3870143719;
        // @xaoxuu: 生产日期
//        time_t now;
//        time(&now);
//        file_id.time_created = now;
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FILE_ID], FIT_FILE_ID_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &file_id, FIT_FILE_ID_MESG_SIZE, fp);
    }
    
    
    // Write a Field Description
    {
        FIT_UINT8 local_mesg_number = 1;
        FIT_FIELD_DESCRIPTION_MESG field_description_mesg;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_FIELD_DESCRIPTION], &field_description_mesg);
        field_description_mesg.developer_data_index = 0;
        field_description_mesg.field_definition_number = 0;
        field_description_mesg.fit_base_type_id = FIT_BASE_TYPE_UINT16;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_FIELD_DESCRIPTION], FIT_FIELD_DESCRIPTION_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &field_description_mesg, FIT_FIELD_DESCRIPTION_MESG_SIZE, fp);
    }
    
    return fp;
}

void fit_record_def(FILE *fp){
    //Record Defenition
    
    {
        FIT_UINT8 local_mesg_number = 2;
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_RECORD],
                               FIT_RECORD_MESG_DEF_SIZE, fp);
    }
    
    
}

void fit_record_msg(FILE *fp, unsigned int timestamp, int position_lat, int position_long, unsigned int distance, unsigned short altitude, unsigned short speed, unsigned char heart_rate){
    //Record message
    {
        FIT_UINT8 local_mesg_number = 2;
        FIT_RECORD_MESG record;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_RECORD], &record);
//        record.timestamp = 702940946;
        
//        record.position_lat = 495280430;
//        record.position_long = -872696681;
//        record.distance = 2;
//        record.altitude = 278.2;
//        record.speed = 0.29;
//        record.heart_rate = 68;
        record.timestamp = timestamp;
        record.position_lat = position_lat;
        record.position_long = position_long;
        record.distance = distance;
        record.altitude = altitude;
        record.speed = speed;
        record.heart_rate = heart_rate;
        WriteMessage(local_mesg_number,&record,FIT_RECORD_MESG_SIZE,fp);
    }
}


void fit_commit_transaction(FILE *fp){
    //Session message
    {
        FIT_UINT8 local_mesg_number = 3;
        FIT_SESSION_MESG session;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_SESSION], &session);
        session.sport = FIT_SPORT_RUNNING;
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_SESSION],
                               FIT_SESSION_MESG_DEF_SIZE, fp); //所有字段定义过长，正尝试如何裁剪
        WriteMessage(local_mesg_number, &session, FIT_SESSION_MESG_SIZE, fp);
        
    }
    
    //Activity message
    {
        FIT_UINT8 local_mesg_number = 4;
        FIT_ACTIVITY_MESG activity;
        
        Fit_InitMesg(fit_mesg_defs[FIT_MESG_ACTIVITY], &activity);
        activity.num_sessions = 1;
        
        WriteMessageDefinition(local_mesg_number, fit_mesg_defs[FIT_MESG_ACTIVITY],
                               FIT_ACTIVITY_MESG_DEF_SIZE, fp);
        WriteMessage(local_mesg_number, &activity, FIT_ACTIVITY_MESG_SIZE, fp);
        
    }
    
    
    
    // Write CRC.
    fwrite(&data_crc, 1, sizeof(FIT_UINT16), fp);
    
    // Update file header with data size.
    WriteFileHeader(fp);
    
    fclose(fp);

}



void fit_transaction(const char *path, void (^record)(FILE *fp)) {
    FILE *fp = fit_start_transaction(path);
    fit_record_def(fp);
    record(fp);
    fit_commit_transaction(fp);
    
}


void WriteFileHeader(FILE *fp)
{
    FIT_FILE_HDR file_header;
    
    file_header.header_size = FIT_FILE_HDR_SIZE;
    file_header.profile_version = FIT_PROFILE_VERSION;
    file_header.protocol_version = FIT_PROTOCOL_VERSION_20;
    memcpy((FIT_UINT8 *)&file_header.data_type, ".FIT", 4);
    fseek (fp , 0 , SEEK_END);
    file_header.data_size = ftell(fp) - FIT_FILE_HDR_SIZE - sizeof(FIT_UINT16);
    file_header.crc = FitCRC_Calc16(&file_header, FIT_STRUCT_OFFSET(crc, FIT_FILE_HDR));
    
    fseek (fp , 0 , SEEK_SET);
    fwrite((void *)&file_header, 1, FIT_FILE_HDR_SIZE, fp);
}

void WriteMessageDefinition(FIT_UINT8 local_mesg_number, const void *mesg_def_pointer, FIT_UINT8 mesg_def_size, FILE *fp)
{
    FIT_UINT8 header = local_mesg_number | FIT_HDR_TYPE_DEF_BIT;
    WriteData(&header, FIT_HDR_SIZE, fp);
    WriteData(mesg_def_pointer, mesg_def_size, fp);
}

void WriteMessageDefinitionWithDevFields
(
 FIT_UINT8 local_mesg_number,
 const void *mesg_def_pointer,
 FIT_UINT8 mesg_def_size,
 FIT_UINT8 number_dev_fields,
 FIT_DEV_FIELD_DEF *dev_field_definitions,
 FILE *fp
 )
{
    FIT_UINT16 i;
    FIT_UINT8 header = local_mesg_number | FIT_HDR_TYPE_DEF_BIT | FIT_HDR_DEV_DATA_BIT;
    WriteData(&header, FIT_HDR_SIZE, fp);
    WriteData(mesg_def_pointer, mesg_def_size, fp);
    
    WriteData(&number_dev_fields, sizeof(FIT_UINT8), fp);
    for (i = 0; i < number_dev_fields; i++)
    {
        WriteData(&dev_field_definitions[i], sizeof(FIT_DEV_FIELD_DEF), fp);
    }
}

void WriteMessage(FIT_UINT8 local_mesg_number, const void *mesg_pointer, FIT_UINT8 mesg_size, FILE *fp)
{
    WriteData(&local_mesg_number, FIT_HDR_SIZE, fp);
    WriteData(mesg_pointer, mesg_size, fp);
}

void WriteDeveloperField(const void *data, FIT_UINT8 data_size, FILE *fp)
{
    WriteData(data, data_size, fp);
}

void WriteData(const void *data, FIT_UINT8 data_size, FILE *fp)
{
    FIT_UINT8 offset;
    
    fwrite(data, 1, data_size, fp);
    
    for (offset = 0; offset < data_size; offset++)
        data_crc = FitCRC_Get16(data_crc, *((FIT_UINT8 *)data + offset));
}
