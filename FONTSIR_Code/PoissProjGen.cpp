#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if(nrhs!=3)
    {
        mexErrMsgTxt("Three inputs required.");
    }else if(nlhs>1)
    {
        mexErrMsgTxt("Too many output arguments.");
    }
    if (!mxIsDouble(prhs[0]))
    {
        mexErrMsgTxt("First Input must be double image.");
    }
    if (!mxIsStruct(prhs[1]))
    {
        mexErrMsgTxt("Second Input must be system matrix.");
    }
    if (!mxIsDouble(prhs[2]))
    {
        mexErrMsgTxt("Third Input must be phaton number.");
    }
    
    int view, dectNum;
    double *imPoint = mxGetPr(prhs[0]);
    int row = mxGetM(prhs[0]);
    int col = mxGetN(prhs[0]);

    const char * valName = mxGetFieldNameByNumber(prhs[1],0);
    mxArray *valCell = mxGetField(prhs[1],0,valName);
    const char *indName = mxGetFieldNameByNumber(prhs[1],1);
    mxArray *indCell = mxGetField(prhs[1],0,indName);
    view = *(mxGetDimensions(indCell)+1);
    mxArray *tmp = mxGetCell(indCell,0);
    dectNum = *(mxGetDimensions(tmp)+1);

    plhs[0]=mxCreateDoubleMatrix(row,col,mxREAL);
    double *gradPoint = mxGetPr(plhs[0]);

    for (int i =0;i<view;i++)
    {
        mxArray *tmp1 = mxGetCell(indCell,i);
        mxArray *tmp2 = mxGetCell(valCell,i);
        for (int j=0;j<dectNum;j++)
        {
            mxArray *indMatrix = mxGetCell(tmp1,j);
            mxArray *valMatrix = mxGetCell(tmp2,j);
            int num = mxGetN(indMatrix);
            double projVal = 0;
            double *ind = mxGetPr(indMatrix);
            double *val = mxGetPr(valMatrix); 
            double *phantonNum = mxGetPr(prhs[2]);
            for (int k=0;k<num;k++)
            {                
                projVal += *(imPoint + static_cast<int>(*(ind + k)) - 1)**(val + k);//前面部分代表矩阵的第几个格子
            }        
            for (int k=0;k<num;k++)
            {
                *(gradPoint + static_cast<int>(*(ind + k)) - 1) += *(val + k)*projVal**(phantonNum + j*view+i);
            }
        } 
    }    
}