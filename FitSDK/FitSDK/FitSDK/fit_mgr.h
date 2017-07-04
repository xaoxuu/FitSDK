////////////////////////////////////////////////////////////////////////////////
// The following FIT Protocol software provided may be used with FIT protocol
// devices only and remains the copyrighted property of Dynastream Innovations Inc.
// The software is being provided on an "as-is" basis and as an accommodation,
// and therefore all warranties, representations, or guarantees of any kind
// (whether express, implied or statutory) including, without limitation,
// warranties of merchantability, non-infringement, or fitness for a particular
// purpose, are specifically disclaimed.
//
// Copyright 2017 Dynastream Innovations Inc.
////////////////////////////////////////////////////////////////////////////////
// ****WARNING****  This file is auto-generated!  Do NOT edit this file.
// Profile Version = 20.30Release
// Tag = production/akw/20.30.00-0-g980332b
// Product = EXAMPLE
// Alignment = 4 bytes, padding disabled.
////////////////////////////////////////////////////////////////////////////////



#ifndef FitSdkManager_h
#define FitSdkManager_h

int createTestFit(const char *path);

// 开始
//FILE *fit_start_transaction(const char *path);
// record
void fit_record_def(FILE *fp);
// record
void fit_record_msg(FILE *fp, unsigned int timestamp, int position_lat, int position_long, unsigned int distance, unsigned short altitude, unsigned short speed, unsigned char heart_rate);
// 提交
//void fit_commit_transaction(FILE *fp);

// 创建fit文件
void fit_transaction(const char *path, void (^record)(FILE *fp));



#endif /* FitSdkManager_h */