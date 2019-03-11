#cmd启动selenium (java -jar selenium-server-standalone-3.8.1.jar)
library(RSelenium)
library(rvest)
library(downloader)

ur_username='put ur username in'
ur_password='put ur password in'
################################Login Part#########################
#start browser
remDr <- remoteDriver('localhost',4444L,browserName = "firefox")
remDr$open()  # 打开
# open the login page of Sina Weibo
url <- 'https://passport.weibo.cn/signin/login'
remDr$navigate(url)
#the element for username
username=remDr$findElement(using='css selector',value='#loginName')
username$clearElement()
username$sendKeysToElement(as.list(ur_username))
Sys.sleep(2)
#the element for password
pwd=remDr$findElement(using='css selector',value='#loginPassword')
pwd$clearElement()
pwd$sendKeysToElement(as.list(ur_password))
Sys.sleep(2)
#click the login button
login_button=remDr$findElement(using='css selector',value='#loginAction')
login_button$clickElement()



###############################Get The 1st Page Resource Part##################
#access the main page
my_page=remDr$findElement(using='css selector',value='.lite-iconf-profile')
my_page$clickElement()
#get the number of Weibo, followings and followers
num_elements=remDr$findElements(using = 'xpath',value='//span[@class="prf-num"]')
num=unlist(sapply(num_elements,function(x){x$getElementAttribute('title')}))
#download my image
my_image=remDr$findElement(using = 'xpath',value='//div[@class="m-img-box"]/img')
my_image_url=my_image$getElementAttribute('src')[[1]]
download.file(url = my_image_url, destfile='my_image.jpg',mode='wb')
#my Weibo Name
Weibo_name_element=remDr$findElement(using = 'xpath',value = '//h3[@class="m-box"]/span[@class="m-text-cut"]')
Weibo_name=Weibo_name_element$getElementText()[[1]]
#my Weibo Introduction
Weibo_introduction_element=remDr$findElement(using = 'xpath',value = '//h4[@class="m-text-cut-2"]')
Weibo_introduction=Weibo_introduction_element$getElementText()[[1]]
#get the entire follow button
follow_button_element=remDr$findElements(using='xpath',value='//span[@class="prf-num"]/b[@class="text-center"]')
#go to the following
following_button_element=follow_button_element[[2]]
following_button_element$clickElement()
last_height = 0
repeat {
  remDr$executeScript("window.scrollTo(0,document.body.scrollHeight);", list(remDr$findElement(using = 'xpath',value = '//div[@class="m-box"]')))
  Sys.sleep(1) 
  new_height=remDr$executeScript("return document.body.scrollHeight", list(remDr$findElement(using = 'xpath',value = '//div[@class="m-box"]')))
  if(unlist(last_height) == unlist(new_height)) {break} else 
  {last_height = new_height} 
}
following_ID_element=remDr$findElements(using='xpath',value = '//div[@class="m-text-box"]/h3/span')
following_ID=unlist(sapply(following_ID_element,function(x){x$getElementText()}))
following_itr_element=remDr$findElements(using='xpath',value = '//div[@class="m-text-box"]/h4[@class="m-text-cut"]')
following_itr=unlist(sapply(following_itr_element,function(x){x$getElementText()}))
following_itr=following_itr[seq(1,length(following_itr),2)]
following_exc_element=remDr$findElements(using='xpath',value = '//div[@class="m-add-box m-add-al"]/h4')
following_exc=unlist(sapply(following_exc_element,function(x){x$getElementText()}))
#go to the follower
remDr$goBack()
follow_button_element=remDr$findElements(using='xpath',value='//span[@class="prf-num"]/b[@class="text-center"]')
follower_button_element=follow_button_element[[3]]
follower_button_element$clickElement()
last_height = 0
repeat {
  remDr$executeScript("window.scrollTo(0,document.body.scrollHeight);", list(remDr$findElement(using = 'xpath',value = '//div[@class="card-main"]')))
  Sys.sleep(1) 
  new_height=remDr$executeScript("return document.body.scrollHeight", list(remDr$findElement(using = 'xpath',value = '//div[@class="card-main"]')))
  if(unlist(last_height) == unlist(new_height)) {break} else 
  {last_height = new_height} 
}
follower_ID_element=remDr$findElements(using='xpath',value = '//div[@class="m-text-box"]/h3/span')
follower_ID=unlist(sapply(follower_ID_element,function(x){x$getElementText()}))
follower_itr_element=remDr$findElements(using='xpath',value = '//div[@class="m-text-box"]/h4[@class="m-text-cut"]')
follower_itr=unlist(sapply(follower_itr_element,function(x){x$getElementText()}))
follower_itr=follower_itr[seq(1,length(follower_itr),2)]
follower_exc_element=remDr$findElements(using='xpath',value = '//div[@class="box-right m-box-center-a m-box-center m-btn-box"]/div/div/h4')
follower_exc=unlist(sapply(follower_exc_element,function(x){x$getElementText()}))

##########################Get The Main Page Resource Part##############
#click the button for 'all your Weibo content'
remDr$goBack()
all_content_button=remDr$findElement(using = 'xpath',value='//div[@class="lite-btn-more"]')
all_content_button$clickElement()
#move ur mouse
#模拟滚动条下拉过程,将整个界面加载出来,再分别提取所需信息
#执行JavaScript片段,单位拉取长度=页面剩余高度,循环拉取,每次拉取都记录新的总高度,直至总高度不在发生变化,则停止下拉
last_height = 0
repeat {
  remDr$executeScript("window.scrollTo(0,document.body.scrollHeight);", list(remDr$findElement(using = 'xpath',value = '//div[@class="weibo-text"]')))
  Sys.sleep(1) 
  new_height=remDr$executeScript("return document.body.scrollHeight", list(remDr$findElement(using = 'xpath',value = '//div[@class="weibo-text"]')))
  if(unlist(last_height) == unlist(new_height)) {break} else 
  {last_height = new_height} 
}
#get all the text of ur Weibo
page_content_all_element=remDr$findElements(using = 'xpath',value = '//article[@class="weibo-main"]')
page_content_all=unlist(sapply(page_content_all_element,function(x){x$getElementText()}))
#get the text of Weibo content for Original
page_content_og_element=remDr$findElements(using = 'xpath',value = '//div[@class="weibo-og"]/div[@class="weibo-text"]')
page_content_og=unlist(sapply(page_content_og_element,function(x){x$getElementText()}))
#get the text of Weibo content for Repost
page_content_rp_element=remDr$findElements(using = 'xpath',value = '//div[@class="weibo-rp"]/div[@class="weibo-text"]')
page_content_rp=unlist(sapply(page_content_rp_element,function(x){x$getElementText()}))
#get the photo of ur ogS
og_image=remDr$findElements(using = 'xpath',value = '//div[@class="weibo-og"]/div/div/div/img')
og_image_url=unlist(sapply(og_image,function(x){x$getElementAttribute('src')}))
num_og_image=length(og_image_url)
for(i in 1:num_og_image){
  download.file(url = og_image_url[i], destfile=paste('OgImage_',i,'.jpg'),mode='wb')
}
#get the time when you sent Weibo
time_usent_element=remDr$findElements(using = 'xpath',value='//h4[@class="m-text-cut"]/span[@class="time"]')
time_usent=unlist(sapply(time_usent_element,function(x){x$getElementText()}))
#get the methods what you used to send Weibo
method_usent_elemtn=remDr$findElements(using = 'xpath',value='//h4[@class="m-text-cut"]/span[@class="from"]')
method_usent=unlist(sapply(method_usent_elemtn,function(x){x$getElementText()}))
#get the num of repost
all_num_element=remDr$findElements(using = 'xpath',value='//div[@class="m-diy-btn m-box-col m-box-center m-box-center-a"]/h4')
all_num=unlist(sapply(all_num_element,function(x){x$getElementText()}))
all_num=all_num[-which(all_num=='公开')]
re_num=all_num[seq(1,length(all_num),3)]
com_num=all_num[seq(2,length(all_num),3)]
like_num=all_num[seq(3,length(all_num),3)]

#back button
#back_button=remDr$findElement(using='css selector',value = '.nav-ctrl')
#back_button$clickElement() 


######################integrate the info you've gotten####
my_main_page_info=data.frame(time_usent,method_usent,re_num,com_num,like_num,page_content_all,page_content_og)
num
page_content_rp
following_info=data.frame(following_ID,following_itr,following_exc)
follower_info=data.frame(follower_ID,follower_itr,follower_exc)

##########################################Sth. else
#close the window
remDr$closeWindow()

