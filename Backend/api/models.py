from django.db import models

# Create your models here.

from django.db import models


class User(models.Model):
    nick = models.CharField(max_length=50, unique=True)
    email = models.EmailField(unique=True)
    password_hash = models.CharField(max_length=255)
    dragon_name = models.CharField(max_length=50, default="Smoczek")
    total_points = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nick


class Class(models.Model):
    class_name = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    display_order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.class_name


class Category(models.Model):
    class_fk = models.ForeignKey(Class, on_delete=models.CASCADE, related_name='categories')
    category_name = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    icon_url = models.URLField(blank=True)
    display_order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.category_name


class Course(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='courses')
    course_name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    video_url = models.URLField(blank=True)
    video_duration = models.PositiveIntegerField(default=0)
    points_per_question = models.IntegerField(default=1)
    required_correct_answers = models.PositiveIntegerField(default=5)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.course_name


class DifficultyLevel(models.Model):
    level_name = models.CharField(max_length=50)
    level_code = models.CharField(max_length=20)
    display_order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.level_name


class Question(models.Model):
    QUESTION_TYPES = [
        ('open', 'Open'),
        ('closed', 'Closed'),
        ('multiple_choice', 'Multiple Choice'),
    ]

    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='questions')
    difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    question_type = models.CharField(max_length=20, choices=QUESTION_TYPES)
    question_text = models.TextField()
    correct_answer = models.CharField(max_length=255)
    points = models.IntegerField(default=1)
    explanation = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.question_text[:50]


class AnswerOption(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='options')
    option_text = models.CharField(max_length=255)
    is_correct = models.BooleanField(default=False)
    display_order = models.PositiveIntegerField(default=0)

    def __str__(self):
        return self.option_text


class UserCourseProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='progress')
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    is_completed = models.BooleanField(default=False)
    current_difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    correct_answers_count = models.PositiveIntegerField(default=0)
    total_attempts = models.PositiveIntegerField(default=0)
    points_earned = models.IntegerField(default=0)
    video_watched = models.BooleanField(default=False)
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)


class UserAnswer(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    user_answer = models.TextField()
    is_correct = models.BooleanField(default=False)
    points_earned = models.IntegerField(default=0)
    time_spent = models.PositiveIntegerField(default=0)
    answered_at = models.DateTimeField(auto_now_add=True)


class Achievement(models.Model):
    achievement_name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    icon_url = models.URLField(blank=True)
    points_reward = models.IntegerField(default=0)
    requirement_type = models.CharField(max_length=50)
    requirement_value = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.achievement_name


class UserAchievement(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    achievement = models.ForeignKey(Achievement, on_delete=models.CASCADE)
    unlocked_at = models.DateTimeField(auto_now_add=True)