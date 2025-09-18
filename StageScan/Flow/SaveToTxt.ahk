#Requires AutoHotkey v2.0
; ======= 配置部分 =======
global FileIndex := 1
SaveFolder := "C:\Users\userz\Documents\DataSet\数据\"   ; 修改为你自己的文件夹路径（必须已存在）

; ======= 鼠标坐标配置 =======
ScanButtonX := 653      ; 单次扫描按钮的X坐标（请修改为实际坐标）
ScanButtonY := 1061      ; 单次扫描按钮的Y坐标（请修改为实际坐标）
MoveButtonX := 200      ; 位移按钮的X坐标（请修改为实际坐标）
MoveButtonY := 200      ; 位移按钮的Y坐标（请修改为实际坐标）

; ======= 主热键：Alt+X =======
!x::
{
    global FileIndex, SaveFolder  ; 声明使用全局变量

    ; 清空剪贴板
    A_Clipboard := ""
    Send("^c")

    ; 等待剪贴板有内容（最多1秒）
    if !ClipWait(1) {
        MsgBox "没有检测到可复制的内容！"
        return
    }

    ; 构造文件路径
    FilePath := SaveFolder FileIndex ".txt"

    ; 将内容写入文件（覆盖写）
    FileDelete(FilePath) ; 如果存在旧文件就删除，避免残留
    FileAppend(A_Clipboard "`r`n", FilePath, "UTF-8")

    ; 编号加一
    FileIndex++
}

; ======= 重置热键：Alt+R =======
!r::
{
    global FileIndex
    FileIndex := 1
    MsgBox "编号已重置为 1"
}

; ======= 自动化流程热键：Alt+Z =======
!z::
{
    global FileIndex, SaveFolder, ScanButtonX, ScanButtonY, MoveButtonX, MoveButtonY
    
    MsgBox "自动化流程开始！按确定继续..."
    
    Loop {
        ; 1. 点击"单次扫描"按钮
        Click(ScanButtonX, ScanButtonY)
        
        ; 2. 等待6.5秒
        Sleep(6500)
        
        ; 3. 执行保存功能
        ; 清空剪贴板
        A_Clipboard := ""
        Send("^c")
        Sleep(500)
        
        ; 等待剪贴板有内容（最多1秒）
        if !ClipWait(1) {
            MsgBox "没有检测到可复制的内容！流程终止。"
            break
        }
        
        ; 构造文件路径
        FilePath := SaveFolder FileIndex ".txt"
        
        ; 检查下一个文件的路径是否存在（判断是否应该停止）
        NextFilePath := SaveFolder (FileIndex + 1) ".txt"
        if !DirExist(SaveFolder) {
            MsgBox "保存文件夹不存在！流程终止。"
            break
        }
        
        ; 将内容写入文件（覆盖写）
        FileDelete(FilePath) ; 如果存在旧文件就删除，避免残留
        try {
            FileAppend(A_Clipboard "`r`n", FilePath, "UTF-8")
        } catch {
            MsgBox "文件保存失败！流程终止。"
            break
        }
        
        ; 编号加一
        FileIndex++
        
        ; 4. 点击"位移"按钮
        Click(MoveButtonX, MoveButtonY)
        
        ; 短暂延迟，避免操作过快
        Sleep(500)
    }
    
    MsgBox "自动化流程已结束。"
}

F1::
{
    MouseGetPos(&x, &y)
    MsgBox("当前鼠标坐标: X=" x " Y=" y)
}