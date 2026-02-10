"""animal_breed URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [
    path('index/',views.index),
    path('login_get/',views.login_get),
    path('login_post/',views.login_post),
    path('admin_home/',views.admin_home),

    path('add_wild_places/',views.add_wild_places),
    path('add_wildlife_place_post/',views.add_wildlife_place_post),
    path('view_wild_places/',views.view_wild_places),
    path('edit_wildlife_place_get/<id>',views.edit_wildlife_place_get),
    path('edit_wildlife_place_post/',views.edit_wildlife_place_post),

    path('admin_verify_agent_get/',views.admin_verify_agent_get),
    path('admin_verify_agent_post/',views.admin_verify_agent_post),

    path('admin_view_users_get/',views.admin_view_users_get),
    path('admin_view_complaints/',views.admin_view_complaints),
    path('admin_view_feedback/',views.admin_view_feedback),
    path('admin_view_Place_rating/',views.admin_view_Place_rating),

    path('changepwd_admin_get/',views.changepwd_admin_get),
    path('changepwd_admin_post/',views.changepwd_admin_post),

    # ====================agent

    path('agent_register_get/',views.agent_register_get),
    path('agent_register_post/',views.agent_register_post),
    path('agent_home/',views.agent_home),
    path('agent_viewprofile/',views.agent_viewprofile),
    path('agent_edit_profile_get/<id>',views.agent_edit_profile_get),
    path('agent_edit_profile_post/',views.agent_edit_profile_post),
    path('changepwd_agent_get/',views.changepwd_agent_get),
    path('changepwd_agent_post/',views.changepwd_agent_post),

    path('agent_view_places/',views.agent_view_places),
    path('agent_add_package_get/<id>',views.agent_add_package_get),
    path('agent_add_package_post/',views.agent_add_package_post),
    path('agent_view_package/',views.agent_view_package),
    path('agent_edit_package/<id>',views.agent_edit_package),
    path('edit_package_post/',views.edit_package_post),
    path('agent_delete_package/<id>',views.agent_delete_package),

    path('agent_add_guides_get/',views.agent_add_guides_get),
    path('add_guide_post/',views.add_guide_post),
    path('agent_view_guides/',views.agent_view_guides),
    path('agent_edit_guide/<id>',views.agent_edit_guide),
    path('agent_edit_guide_post/',views.agent_edit_guide_post),
    path('agent_delete_guide/<id>',views.agent_delete_guide),

    path('assign_guide_to_package/<id>',views.assign_guide_to_package),
    path('agent_assign_guide_post/',views.agent_assign_guide_post),
    path('agentview_assign_package/',views.agentview_assign_package),
    path('delete_assign_package/<id>',views.delete_assign_package),

    # =================GUIDE

    path('flutter_login/',views.flutter_login),
    path('guide_viewprofile/',views.guide_viewprofile),
    path('guide_view_assipackages/',views.guide_view_assipackages),
    path('guide_accept_package/',views.guide_accept_package),
    path('guide_reject_package/',views.guide_reject_package),

    # =================USER

    path('user_register/',views.user_register),
    path('user_viewprofile/',views.user_viewprofile),
    path('user_profileviewforedit/',views.user_profileviewforedit),
    path('user_editprofile/',views.user_editprofile),
    path('user_viewplaces/',views.user_viewplaces),

]
