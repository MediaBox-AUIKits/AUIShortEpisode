package com.aliyun.auishortepisode;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.alivc.auiplayer.videoepisode.AUIEpisodePlayerActivity;
import com.aliyun.auishortepisode.utils.PermissionUtils;
import com.aliyun.auishortepisode.view.AVBaseListActivity;

import java.util.ArrayList;
import java.util.List;

public class PlayerMainActivity extends AVBaseListActivity {

    private static final int REQUEST_PERMISSION_STORAGE = 0x0001;

    private static final int INDEX_VIDEO_LIST_SHORT = 3;


    private ListModel mListModel;

    @Override
    public int getTitleResId() {
        return R.string.player_video_list;
    }

    @Override
    public boolean showBackBtn() {
        return !isTaskRoot();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        hideSystemStatusBar();
    }

    @Override
    public List<ListModel> createListData() {
        List<ListModel> menu = new ArrayList<>();
        menu.add(new ListModel(INDEX_VIDEO_LIST_SHORT, R.drawable.ic_player_chenjin, getResources().getString(R.string.player_videolist_episode), getResources().getString(R.string.player_video_episode_msg)));
        return menu;
    }

    @Override
    public void onListItemClick(ListModel model) {
        mListModel = model;
        String[] per = Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ?
                new String[] {Manifest.permission.READ_EXTERNAL_STORAGE} :
                new String[] {Manifest.permission.READ_MEDIA_IMAGES,
                        Manifest.permission.READ_MEDIA_VIDEO,
                        Manifest.permission.READ_MEDIA_AUDIO};
        if (PermissionUtils.checkPermissionsGroup(this, per)) {
            ActivityCompat.requestPermissions((Activity) this, per, REQUEST_PERMISSION_STORAGE);
        } else {
            onModelItemClick(model);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        boolean isAllGranted = true;

        // 判断是否所有的权限都已经授予了
        for (int grant : grantResults) {
            if (grant != PackageManager.PERMISSION_GRANTED) {
                isAllGranted = false;
                break;
            }
        }

        if (!isAllGranted) {
            // 弹出对话框告诉用户需要权限的原因, 并引导用户去应用权限管理中手动打开权限按钮
            Toast.makeText(this, getString(R.string.alivc_recorder_camera_permission_tip), Toast.LENGTH_SHORT).show();
        } else {
            onModelItemClick(mListModel);
        }
    }

    private void onModelItemClick(ListModel model) {
        switch (model.index) {
            case INDEX_VIDEO_LIST_SHORT: {
                Intent videoListIntent = new Intent(this, AUIEpisodePlayerActivity.class);
                startActivity(videoListIntent);
                break;
            }
        }
    }

    private void hideSystemStatusBar() {
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
    }

}
