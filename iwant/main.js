defineClass('LuckController', {
            viewWillAppear:function(animated) {
            var alertView = require('UIAlertView').alloc().init();
            alertView.setTitle('声明');
            alertView.setMessage('本次抽奖活动与苹果公司无关，奖品全部来自于三川汇通北京科技发展有限公司');
            alertView.addButtonWithTitle('知道了。');
            alertView.show();
            }
            })
