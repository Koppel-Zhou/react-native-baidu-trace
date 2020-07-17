package com.reactlibrary;

import android.util.Log;

import com.baidu.trace.api.entity.OnEntityListener;
import com.baidu.trace.api.entity.UpdateEntityRequest;
import com.baidu.trace.api.entity.UpdateEntityResponse;
import com.baidu.trace.model.PushMessage;
import com.baidu.trace.Trace;
import com.baidu.trace.LBSTraceClient;
import com.baidu.trace.model.OnTraceListener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;

public class BaiduTraceModule extends ReactContextBaseJavaModule {
    public static final String ON_START_TRACE = "BAIDU_TRACE_ON_START_TRACE";
    public static final String ON_STOP_TRACE = "BAIDU_TRACE_ON_STOP_TRACE";
    public static final String ON_START_GATHER = "BAIDU_TRACE_ON_START_GATHER";
    public static final String ON_STOP_GATHER = "BAIDU_TRACE_ON_STOP_GATHER";
    public static final String ON_BIND_SERVICE = "BAIDU_TRACE_ON_BIND_SERVICE";
    public static final String ON_PUSH = "BAIDU_TRACE_ON_PUSH_MESSAGE";
    public static final String ON_UPDATE_ENTITY = "BAIDU_TRACE_ON_UPDATE_ENTITY";
    private static ReactApplicationContext reactContext = null;
    private LBSTraceClient mTraceClient = null;
    private Trace mTrace = null;
    private OnEntityListener entityListener = null;

    private long serviceId = 0;
    private String entityName = "";
    private String entityDesc = "";
    private boolean isNeedObjectStorage = false;
    // 定位周期(单位:秒)
    private int gather = 5;
    // 打包回传周期(单位:秒)
    private int pack = 10;

    public BaiduTraceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "BaiduTrace";
    }

    @ReactMethod
    public void initService(ReadableMap config) {
        Log.i("ON_SINIT_TRACE", config.toString());
        // 轨迹服务ID
        serviceId = config.getInt("serviceId");
        // 设备标识
        entityName = config.getString("entityName");
        entityDesc = config.getString("entityDesc");
        // 是否需要对象存储服务，默认为：false，关闭对象存储服务。注：鹰眼 Android SDK v3.0以上版本支持随轨迹上传图像等对象数据，若需使用此功能，该参数需设为 true，且需导入bos-android-sdk-1.0.2.jar。
        isNeedObjectStorage = config.getBoolean("isNeedObjectStorage");
        // 初始化轨迹服务
        this.mTrace = new Trace(serviceId, entityName, isNeedObjectStorage);
        // 初始化轨迹服务客户端
        if (getReactApplicationContext() != null) {
            this.mTraceClient = new LBSTraceClient(getReactApplicationContext());
        }
    }

    // 设置定位和打包周期
    @ReactMethod
    public void setGatherAndPackInterval(Integer gatherInterval, Integer packInterval) {
        gather = gatherInterval;
        pack = packInterval;
        mTraceClient.setInterval(gather, pack);
    }

    public static void sendEvent(String eventName, Integer status, String message) {
        WritableMap params = Arguments.createMap();
        params.putInt("status", status);
        params.putString("message", message);
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    // 初始化轨迹服务监听器
    OnTraceListener mTraceListener = new OnTraceListener() {
        // 开启服务回调
        @Override
        public void onStartTraceCallback(int status, String message) {
            Log.i("ON_START_TRACE", status + message);
            BaiduTraceModule.sendEvent(ON_START_TRACE, status, message);
        }
        // 停止服务回调
        @Override
        public void onStopTraceCallback(int status, String message) {
            Log.i("ON_STOP_TRACE", status + message);
            BaiduTraceModule.sendEvent(ON_STOP_TRACE, status, message);
        }
        // 开启采集回调
        @Override
        public void onStartGatherCallback(int status, String message) {
            Log.i("ON_START_GATHER", status + message);
            BaiduTraceModule.sendEvent(ON_START_GATHER, status, message);
        }
        // 停止采集回调
        @Override
        public void onStopGatherCallback(int status, String message) {
            Log.i("ON_STOP_GATHER", status + message);
            BaiduTraceModule.sendEvent(ON_STOP_GATHER, status, message);
        }
        // 推送回调
        @Override
        public void onPushCallback(byte messageNo, PushMessage message) {
            int msgNo = Integer.valueOf(messageNo);
            BaiduTraceModule.sendEvent(ON_PUSH, msgNo, message.getMessage());
        }

        @Override
        public  void onBindServiceCallback(int status, String message) {
            BaiduTraceModule.sendEvent(ON_BIND_SERVICE, status, message);
        }

        @Override
        public  void onInitBOSCallback(int status, String message) {}
    };

    @ReactMethod
    public void startTrace() {
        // 开启鹰眼服务，启动鹰眼 service
        mTraceClient.startTrace(mTrace, mTraceListener);
    }

    @ReactMethod
    public void startGather() {
        // 开启采集
        // 注意：因为startTrace与startGather是异步执行，且startGather依赖startTrace执行开启服务成功，
        // 所以建议startGather在public void onStartTraceCallback(int errorNo, String message)回调返回错误码为0后，
        // 再进行调用执行，否则会出现服务开启失败12002的错误。
        mTraceClient.startGather(mTraceListener);
    }

    @ReactMethod
    public void updateEntity(ReadableMap config) {
        ReadableNativeMap map = (ReadableNativeMap) config;
        HashMap map2 = map.toHashMap();
        UpdateEntityRequest request = new UpdateEntityRequest(0 , serviceId, entityName, entityDesc, map2);
        mTraceClient.updateEntity(request, new OnEntityListener() {
            @Override
            public void onUpdateEntityCallback(UpdateEntityResponse res)  {
                BaiduTraceModule.sendEvent(ON_UPDATE_ENTITY, res.status, res.message);
            }
        });
    }

    @ReactMethod
    public void stopTrace() {
        // 停止服务
        // 停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
        mTraceClient.stopTrace(mTrace, mTraceListener);
    }

    @ReactMethod
    public void stopGather() {
        // 停止采集
        // 停止轨迹服务：此方法将同时停止轨迹服务和轨迹采集，完全结束鹰眼轨迹服务。若需再次启动轨迹追踪，需重新启动服务和轨迹采集
        mTraceClient.stopGather(mTraceListener);
    }
}
