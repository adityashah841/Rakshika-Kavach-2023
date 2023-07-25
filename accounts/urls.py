from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.SignUp.as_view(), name='Signup'),
    path('login/', views.Login.as_view(), name='Login'),
    path('phone-verify/', views.VerifyPhoneView.as_view(), name = "PhoneVerify"),
    path('set-login-creds/', views.SetUsernamePasswordView.as_view(), name = "SetUsernamePassword"),
    path('profile/', views.UserView.as_view(), name = "User Profile"),
]