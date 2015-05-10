#-*- coding: utf-8 -*-
from django.shortcuts import render_to_response,HttpResponse
from django.template.loader import get_template
from django.contrib.sessions import serializers

from models import Cart

def index(request):
    title = "首页"
    return render_to_response('index.html', locals())


def category(request):
    title = "目录"
    return render_to_response("category.html", locals())


def dishes(request):
    title = "菜品"
    return render_to_response("dishes.html",locals())

def view_cart(request):
    title = "购物车"
    cart = request.session.get('cart',None)
    if not cart:
        # 购物车空
        cart = Cart()

    request.session['cart_total_price'] = cart.total_price
    request.session['cart_total_items'] = cart.items
    return render_to_response("view_cart.html",locals())