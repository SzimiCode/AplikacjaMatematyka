"""
URL configuration for mathdragon project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
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
from django.conf import settings
from django.http import HttpResponse
from django.urls import path, include
from django.contrib import admin
from django.conf.urls.static import static

# prosta strona glowna - zwraca tekst powitalny
def home(request):
    return HttpResponse("Witaj w MathDragon API!")

urlpatterns = [
    path('', home),  # strona startowa na http://127.0.0.1:8000/
    path('admin/', admin.site.urls),  # panel administracyjny django
    path('api/', include('api.urls')),  # wszystkie endpointy api pod /api/
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATICFILES_DIRS[0])