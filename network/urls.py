from django.urls import path
from . import views

urlpatterns = [
    path('', views.SendRequestView.as_view(), name = 'SendRequest'),
    path('accept/<str:pk>/', views.AcceptWarriorRequestView.as_view(), name = 'AcceptWarriorRequest'),
    path('count/', views.WarriorCountView.as_view(), name = 'WarriorCount'),
    path("notification/<str:pk>/", views.SendNotificationView.as_view(), name = 'Notification'),
    path('notification/accept/<str:pk>/', views.AcceptNotificationRequestView.as_view(), name = 'AcceptNotificationRequest'),
    path("user-notify/", views.NotifyUserRequestView.as_view(), name = 'UserNotify'),
    path("community-users-search/", views.UserCommunityTrustSearch.as_view(), name = "CommunityUsersSearch"),
]