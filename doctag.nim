import  windows,strutils,tables,iup,db_sqlite
discard iup.open(nil, nil)

#�����ϵĿؼ����
var tagTextBox,tagsContainer:PIhandle
var tagsTable = initTable[int,PIhandle]()
#�����ݿ�����
var conn = db_sqlite.open("db.db","","","")

#��ȡ��ǰѡ�е��ļ�
var params = windows.GetCommandLineA()
var targetPath = $cast[cstring](params)
targetPath = targetPath.subStr(targetPath.find(" "))
var targetName = targetPath.subStr(targetPath.rfind("\\")+1)
#todo:ѡ���˶���ļ���ʱ�򣬻�򿪶��ʵ��

#search files
var searchFileContainer = iup.vbox(iup.fill(),nil)
searchFileContainer.setAttribute("TABTITLE","�ļ�����")

#all tags tab
var tag1 = iup.link("http://nim-lang.org/","�ҵı�ǩ")
var allTagsContainer = iup.vbox(tag1,iup.fill(),nil)
allTagsContainer.setAttribute("TABTITLE","���б�ǩ")

#cur file tags tab
proc TagItBtnClick(arg: PIhandle): cint {.cdecl.} =
    var sqlStr = sql("insert into Tag (Tag) values (?)")
    var  val = tagTextBox.getAttribute("VALUE")
    conn.exec(sqlStr,val)
    message("Hello World Message", val)

var label = iup.label("��ǰ�ļ���"&targetName)
discard label.setAttributes("MARGIN=6X6")
tagTextBox = iup.text(nil)
discard tagTextBox.setAttributes("EXPAND=HORIZONTAL,SIZE=x12")
var tagButton = iup.button("���ǩ",nil)
tagButton.setCallback("ACTION", cast[Icallback](TagItBtnClick))

discard tagButton.setAttributes("SIZE=56X")
var tagItContainer = iup.hbox(tagTextBox,tagButton,nil)
discard tagItContainer.setAttributes("GAP=4,MARGIN=0X4X4X4")

tagsContainer = iup.hbox(iup.fill(),nil)
discard tagsContainer.setAttributes("MARGIN=0X4X4X4,GAP=4")

proc showCurDocTags()=    
    var rows = conn.getAllRows(sql"select * from Tag")
    for i in 0 .. rows.len-1:
        var tag = iup.link("http://nim-lang.org/",$rows[i][1])
        tagsTable[rows[i][0].parseInt] = tag
        discard tagsContainer.insert(nil,tag)
    

showCurDocTags()
    
var curFileTagsContainer = iup.vbox(label,tagItContainer,tagsContainer,iup.fill(),nil)
curFileTagsContainer.setAttribute("TABTITLE","���ǩ")
#tabs
var tabs = iup.tabs(curFileTagsContainer,allTagsContainer,searchFileContainer,nil)
var tabsContainer = iup.vbox(tabs,nil)
tabs.setAttribute("EXPAND","YES")
tabsContainer.setAttribute("MARGIN","6x6")
#dialog
var dlg = iup.dialog(tabsContainer)
dlg.setAttribute("TITLE", "�ļ�-��ǩ") #todo
dlg.setAttribute("SIZE", "QUARTERxQUARTER")
discard dlg.showXY(IUP_CENTER, IUP_CENTER)
dlg.setAttribute("USERSIZE",nil)
discard mainLoop()
close()


#   var vbox = iup.vbox(cbox)
#   vbox.setAttribute("TABTITLE","CESHI��������")
#
#
#   var tabs = iup.frame(nil)
#   tabs.setAttribute("EXPAND","YES")
#   tabs.setAttribute("TITLE","YES")
#
#   var fbox = iup.hbox(tabs,nil)
#   fbox.setAttribute("EXPAND","YES")

#import windows,everything_lib
#var str = newWideCString("doctag.nim")
#Everything_SetSearchW(str)
#discard Everything_QueryW(1)
#var rowsNum = Everything_GetNumResults()
#for i in 0..rowsNum-1:
#    var name = Everything_GetResultFileNameW(i)     #$cast[WideCString](lpcwstr)
#    echo( $name )
#echo("ok")