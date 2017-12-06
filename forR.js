/**
 * Created by MaiBenBen on 2017/12/4.
 */
window.onload=function() {
    var container = document.getElementById('container');
    var list = document.getElementById('list');
    var buttons = document.getElementById('buttons').getElementsByTagName('span');
    var pre = document.getElementById('prev');
    var next = document.getElementById('next');
    var index = 1;
    var animated = false;
    var timer;

    function showButton() {
        for (var i = 0; i < buttons.length; i++) {
            if (buttons[i].className == 'on') {
                buttons[i].className = '';
                break;
            }
        }
        buttons[index - 1].className = "on";
    }

    function animate(offset) {
        animated = true;
        var newleft = parseInt(list.style.left) + offset;
        var time = 400;//位移总时间
        var interval = 10;//位移间隔时间
        var speed = offset / (time / interval);//每一次的位移量

        function go() {
            if ((speed < 0 && parseInt(list.style.left) > newleft) || (speed > 0 && parseInt(list.style.left) < newleft)) {
                list.style.left = parseInt(list.style.left) + speed + 'px';
                setTimeout(go, interval);
            }
            else {
                animated = false;
                list.style.left = newleft + 'px';
                if (newleft > -1200) {
                    list.style.left = -6000 + 'px';
                }
                if (newleft < -6000) {
                    list.style.left = -1200 + 'px';
                }
            }
        }

        go();
    }

    /*function play(){
     timer=setInterval(function(){
     next.onclick();
     },4800);
     }
     function stop(){
     clearInterval(timer);
     }*/

    next.onclick = function () {
        if (index == 5) {
            index = 1;
        }
        else {
            index += 1;
        }
        showButton();
        if (animated == false) {
            animate(-1200);
        }
    };
    pre.onclick = function () {
        if (index == 1) {
            index = 5;
        }
        else {
            index -= 1;
        }
        showButton();
        if (animated == false) {
            animate(1200);
        }
    };

    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function () {
            if (this.className == 'on') {
                return;
            }
            var myIndex = parseInt(this.getAttribute('index'));
            var offset = -1200 * (myIndex - index);

            index = myIndex;
            showButton();
            if (animated == false) {
                animate(offset);
            }
        }
    }



    $('.kind div.btn1').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer1').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer1').css("display","none");
        }
    });

    $('.kind div.btn2').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer2').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer2').css("display","none");
        }
    });
    $('.kind div.btn3').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer3').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer3').css("display","none");
        }
    });
    $('.kind div.btn4').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer4').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer4').css("display","none");
        }
    });
    $('.kind div.btn5').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer5').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer5').css("display","none");
        }
    });
    $('.kind div.btn6').click(function(){
        var btn=$(this);
        if (btn.hasClass('button')) {
            btn.removeClass('button');
            btn.addClass('button1');
            $('.kindContainer6').css("display","block");
        }
        else {
            btn.removeClass('button1');
            btn.addClass('button');
            $('.kindContainer6').css("display","none");
        }
    });
    /*container.onmouseover=stop;
     container.onmouseout=play;
     play();禁用滚动*/
    if (!document.getElementsByClassName) {
        document.getElementsByClassName = function (className, element) {
            var children = (element || document).getElementsByTagName('*');
            var elements = new Array();
            for (var i = 0; i < children.length; i++) {
                var child = children[i];
                var classNames = child.className.split(' ');
                for (var j = 0; j < classNames.length; j++) {
                    if (classNames[j] == className) {
                        elements.push(child);
                        break;
                    }
                }
            }
            return elements;
        };
    }//读取IE7&8的className


    /*var menu=document.getElementById("menu");
     var a=menu.getElementsByTagName("a");
     for(var k=0; k< a.length; k++){
     a[k].onclick=function(){
     if(this.className!=='choose') {
     this.className = 'choose';
     }
     else{

     }
     }
     }*/

};