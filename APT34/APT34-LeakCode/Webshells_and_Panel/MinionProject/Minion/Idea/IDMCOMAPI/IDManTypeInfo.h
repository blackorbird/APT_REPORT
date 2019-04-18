/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 5.01.0164 */
/* at Mon Oct 13 07:34:24 2003
 */
/* Compiler settings for C:\users\sansan\testVersion\Downloader\IDManTypeInfo.idl:
    Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
*/
//@@MIDL_FILE_HEADING(  )


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 440
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __IDManTypeInfo_h__
#define __IDManTypeInfo_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __ICIDMLinkTransmitter_FWD_DEFINED__
#define __ICIDMLinkTransmitter_FWD_DEFINED__
typedef interface ICIDMLinkTransmitter ICIDMLinkTransmitter;
#endif 	/* __ICIDMLinkTransmitter_FWD_DEFINED__ */


#ifndef __ICIDMLinkTransmitter2_FWD_DEFINED__
#define __ICIDMLinkTransmitter2_FWD_DEFINED__
typedef interface ICIDMLinkTransmitter2 ICIDMLinkTransmitter2;
#endif 	/* __ICIDMLinkTransmitter2_FWD_DEFINED__ */


#ifndef __CIDMLinkTransmitter_FWD_DEFINED__
#define __CIDMLinkTransmitter_FWD_DEFINED__

#ifdef __cplusplus
typedef class CIDMLinkTransmitter CIDMLinkTransmitter;
#else
typedef struct CIDMLinkTransmitter CIDMLinkTransmitter;
#endif /* __cplusplus */

#endif 	/* __CIDMLinkTransmitter_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __ICIDMLinkTransmitter_INTERFACE_DEFINED__
#define __ICIDMLinkTransmitter_INTERFACE_DEFINED__

/* interface ICIDMLinkTransmitter */
/* [unique][helpstring][oleautomation][uuid][object] */ 


EXTERN_C const IID IID_ICIDMLinkTransmitter;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("4BD46AAE-C51F-4BF7-8BC0-2E86E33D1873")
    ICIDMLinkTransmitter : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE SendLinkToIDM( 
            /* [in] */ BSTR bstrUrl,
            /* [in] */ BSTR bstrReferer,
            /* [in] */ BSTR bstrCookies,
            /* [in] */ BSTR bstrData,
            /* [in] */ BSTR bstrUser,
            /* [in] */ BSTR bstrPassword,
            /* [in] */ BSTR bstrLocalPath,
            /* [in] */ BSTR bstrLocalFileName,
            /* [in] */ long lFlags) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ICIDMLinkTransmitterVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            ICIDMLinkTransmitter __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            ICIDMLinkTransmitter __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            ICIDMLinkTransmitter __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendLinkToIDM )( 
            ICIDMLinkTransmitter __RPC_FAR * This,
            /* [in] */ BSTR bstrUrl,
            /* [in] */ BSTR bstrReferer,
            /* [in] */ BSTR bstrCookies,
            /* [in] */ BSTR bstrData,
            /* [in] */ BSTR bstrUser,
            /* [in] */ BSTR bstrPassword,
            /* [in] */ BSTR bstrLocalPath,
            /* [in] */ BSTR bstrLocalFileName,
            /* [in] */ long lFlags);
        
        END_INTERFACE
    } ICIDMLinkTransmitterVtbl;

    interface ICIDMLinkTransmitter
    {
        CONST_VTBL struct ICIDMLinkTransmitterVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICIDMLinkTransmitter_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ICIDMLinkTransmitter_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ICIDMLinkTransmitter_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ICIDMLinkTransmitter_SendLinkToIDM(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags)	\
    (This)->lpVtbl -> SendLinkToIDM(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE ICIDMLinkTransmitter_SendLinkToIDM_Proxy( 
    ICIDMLinkTransmitter __RPC_FAR * This,
    /* [in] */ BSTR bstrUrl,
    /* [in] */ BSTR bstrReferer,
    /* [in] */ BSTR bstrCookies,
    /* [in] */ BSTR bstrData,
    /* [in] */ BSTR bstrUser,
    /* [in] */ BSTR bstrPassword,
    /* [in] */ BSTR bstrLocalPath,
    /* [in] */ BSTR bstrLocalFileName,
    /* [in] */ long lFlags);


void __RPC_STUB ICIDMLinkTransmitter_SendLinkToIDM_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ICIDMLinkTransmitter_INTERFACE_DEFINED__ */


#ifndef __ICIDMLinkTransmitter2_INTERFACE_DEFINED__
#define __ICIDMLinkTransmitter2_INTERFACE_DEFINED__

/* interface ICIDMLinkTransmitter2 */
/* [unique][helpstring][oleautomation][uuid][object] */ 


EXTERN_C const IID IID_ICIDMLinkTransmitter2;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("94D09862-1875-4FC9-B434-91CF25C840A1")
    ICIDMLinkTransmitter2 : public ICIDMLinkTransmitter
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE SendLinkToIDM2( 
            /* [in] */ BSTR bstrUrl,
            /* [in] */ BSTR bstrReferer,
            /* [in] */ BSTR bstrCookies,
            /* [in] */ BSTR bstrData,
            /* [in] */ BSTR bstrUser,
            /* [in] */ BSTR bstrPassword,
            /* [in] */ BSTR bstrLocalPath,
            /* [in] */ BSTR bstrLocalFileName,
            /* [in] */ long lFlags,
            /* [in] */ VARIANT reserved1,
            /* [in] */ VARIANT reserved2) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SendLinksArray( 
            /* [in] */ BSTR location,
            /* [in] */ VARIANT __RPC_FAR *pLinksArray) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ICIDMLinkTransmitter2Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendLinkToIDM )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This,
            /* [in] */ BSTR bstrUrl,
            /* [in] */ BSTR bstrReferer,
            /* [in] */ BSTR bstrCookies,
            /* [in] */ BSTR bstrData,
            /* [in] */ BSTR bstrUser,
            /* [in] */ BSTR bstrPassword,
            /* [in] */ BSTR bstrLocalPath,
            /* [in] */ BSTR bstrLocalFileName,
            /* [in] */ long lFlags);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendLinkToIDM2 )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This,
            /* [in] */ BSTR bstrUrl,
            /* [in] */ BSTR bstrReferer,
            /* [in] */ BSTR bstrCookies,
            /* [in] */ BSTR bstrData,
            /* [in] */ BSTR bstrUser,
            /* [in] */ BSTR bstrPassword,
            /* [in] */ BSTR bstrLocalPath,
            /* [in] */ BSTR bstrLocalFileName,
            /* [in] */ long lFlags,
            /* [in] */ VARIANT reserved1,
            /* [in] */ VARIANT reserved2);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendLinksArray )( 
            ICIDMLinkTransmitter2 __RPC_FAR * This,
            /* [in] */ BSTR location,
            /* [in] */ VARIANT __RPC_FAR *pLinksArray);
        
        END_INTERFACE
    } ICIDMLinkTransmitter2Vtbl;

    interface ICIDMLinkTransmitter2
    {
        CONST_VTBL struct ICIDMLinkTransmitter2Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICIDMLinkTransmitter2_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ICIDMLinkTransmitter2_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ICIDMLinkTransmitter2_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ICIDMLinkTransmitter2_SendLinkToIDM(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags)	\
    (This)->lpVtbl -> SendLinkToIDM(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags)


#define ICIDMLinkTransmitter2_SendLinkToIDM2(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags,reserved1,reserved2)	\
    (This)->lpVtbl -> SendLinkToIDM2(This,bstrUrl,bstrReferer,bstrCookies,bstrData,bstrUser,bstrPassword,bstrLocalPath,bstrLocalFileName,lFlags,reserved1,reserved2)

#define ICIDMLinkTransmitter2_SendLinksArray(This,location,pLinksArray)	\
    (This)->lpVtbl -> SendLinksArray(This,location,pLinksArray)

#endif /* COBJMACROS */


#endif 	/* C style interface */



HRESULT STDMETHODCALLTYPE ICIDMLinkTransmitter2_SendLinkToIDM2_Proxy( 
    ICIDMLinkTransmitter2 __RPC_FAR * This,
    /* [in] */ BSTR bstrUrl,
    /* [in] */ BSTR bstrReferer,
    /* [in] */ BSTR bstrCookies,
    /* [in] */ BSTR bstrData,
    /* [in] */ BSTR bstrUser,
    /* [in] */ BSTR bstrPassword,
    /* [in] */ BSTR bstrLocalPath,
    /* [in] */ BSTR bstrLocalFileName,
    /* [in] */ long lFlags,
    /* [in] */ VARIANT reserved1,
    /* [in] */ VARIANT reserved2);


void __RPC_STUB ICIDMLinkTransmitter2_SendLinkToIDM2_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE ICIDMLinkTransmitter2_SendLinksArray_Proxy( 
    ICIDMLinkTransmitter2 __RPC_FAR * This,
    /* [in] */ BSTR location,
    /* [in] */ VARIANT __RPC_FAR *pLinksArray);


void __RPC_STUB ICIDMLinkTransmitter2_SendLinksArray_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ICIDMLinkTransmitter2_INTERFACE_DEFINED__ */



#ifndef __IDManLib_LIBRARY_DEFINED__
#define __IDManLib_LIBRARY_DEFINED__

/* library IDManLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_IDManLib;

EXTERN_C const CLSID CLSID_CIDMLinkTransmitter;

#ifdef __cplusplus

class DECLSPEC_UUID("AC746233-E9D3-49CD-862F-068F7B7CCCA4")
CIDMLinkTransmitter;
#endif
#endif /* __IDManLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  BSTR_UserSize(     unsigned long __RPC_FAR *, unsigned long            , BSTR __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * ); 
void                      __RPC_USER  BSTR_UserFree(     unsigned long __RPC_FAR *, BSTR __RPC_FAR * ); 

unsigned long             __RPC_USER  VARIANT_UserSize(     unsigned long __RPC_FAR *, unsigned long            , VARIANT __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  VARIANT_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, VARIANT __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  VARIANT_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, VARIANT __RPC_FAR * ); 
void                      __RPC_USER  VARIANT_UserFree(     unsigned long __RPC_FAR *, VARIANT __RPC_FAR * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif
