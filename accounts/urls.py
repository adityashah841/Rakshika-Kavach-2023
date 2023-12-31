from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.SignUp.as_view(), name='Signup'),
    path('login/', views.Login.as_view(), name='Login'),
    path('phone-verify/', views.VerifyPhoneView.as_view(), name = "PhoneVerify"),
    path('set-login-creds/', views.SetUsernamePasswordView.as_view(), name = "SetUsernamePassword"),
    path('profile/', views.UserView.as_view(), name = "User Profile"),
    path('address/<str:pk>/', views.AddressView.as_view(), name = "User Address"),
    path('emergency-contact/<str:pk>/', views.EmergencyContactView.as_view(), name = "User Emergency Contact"),
    path('get-users/', views.GetUserList.as_view(), name = "get all users")
]