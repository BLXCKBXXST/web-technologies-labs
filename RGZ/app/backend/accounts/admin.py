"""Регистрация моделей accounts в админке."""

from django.contrib import admin

from .models import LoginCode, User


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('email', 'first_name', 'last_name', 'is_active', 'is_staff', 'date_joined')
    search_fields = ('email', 'first_name', 'last_name')
    list_filter = ('is_active', 'is_staff')
    ordering = ('-date_joined',)


@admin.register(LoginCode)
class LoginCodeAdmin(admin.ModelAdmin):
    list_display = ('user', 'purpose', 'created_at', 'expires_at', 'consumed_at', 'attempts')
    list_filter = ('purpose',)
    search_fields = ('user__email',)
    readonly_fields = ('code_hash', 'created_at', 'updated_at')
