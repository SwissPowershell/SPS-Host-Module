Function Write-Line {
<#
    .SYNOPSIS
        Writes customized colored output to a host
    .DESCRIPTION
        The function will give more option on write-host
        It will allow to create borders and colored text in a same line
    .EXAMPLE
        Write-Line -Message "My Text is [Beautiful] and I love this"
        Write to host "My Text is [Beautiful] and I love this" with 'Beautiful' in green
    .EXAMPLE
        Write-Line -Message "This is a title" -Border
        Write to host "This is a title" with a border
    .EXAMPLE
        Write-Line -Message "My flowers are`r`nbeautiful" -Border -BorderFormat Block -Align Right
        Write To host "My flowers are`r`nbeautiful" with border made of block and text aligned to right
    .PARAMETER Message
        Message to display
    .PARAMETER OpenChar
        That define where the colored part will begin (the char is not colored). Default '['
    .PARAMETER CloseChar
        That define where the colored part will end (the char is not colored). Default ']'
    .PARAMETER HideChar
        Will hide OpenChar and CloseChar when writing to host (but text remain colored)
    .PARAMETER Align
        Will align multiline text. Default 'Center'
            Authorized Values :
                Left
                Right
                Center
    .PARAMETER DefaultColor
        Specify default text color. Default 'Cyan'
    .PARAMETER AltColor
        Specify text between OpenChar and CloseChar color. Default 'Green'
    .PARAMETER BorderColor
        Specify Border color. Default Magenta
    .PARAMETER BorderFormat
        Specify the BorderFormat. Default 'Double'
            Autorized Values :
                Single
                SingleBold
                Double
                Mixed1
                Mixed2
                HalfBlock
                Block
                LightShade
                MediumShade
                DarkShade
    .PARAMETER NoNewLine
        Specifies that the content displayed in the console does not end with a newline character.
    .INPUTS
        System.String
    .OUTPUTS
        None
        Write-Line sends the objects to the host. It does not return any objects. However, the host might display the objects that Write-Line sends to it.
    .LINK
        Online Version: http://go.microsoft.com/fwlink/p/?linkid=294029
        Write-Host
        Clear-Host 
        Out-Host 
        Write-Debug 
        Write-Error 
        Write-Output 
        Write-Progress 
        Write-Verbose 
        Write-Warning
    .NOTES
        Written by Yann Girardet
    .FUNCTIONALITY
        To give a sexier look to your host
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True
        )]
        [AllowEmptyString()]
        [String]
            $Message,

        [Char]
            $OpenChar="[",
        
        [ValidateScript({if ($_ -ne $OpenChar){$True}Else{Throw "CloseChar '$_' can't be same as OpenChar '$OpenChar'"}})]
        [Char]
            $CloseChar="]",

        [Switch]
            $HideChar,

        [ValidateSet("Left","Center","Right")]
        [String]
            $Align = "Center",

        [ConsoleColor]
            $DefaultColor="Cyan",

        [ConsoleColor]
            $AltColor="Green",
        
        [ConsoleColor]
            $BorderColor = "Magenta",

        [Switch]
            $Border,

        [ValidateSet("Single","SingleBold","Double","Mixed1","Mixed2","HalfBlock","Block","LightShade","MediumShade","DarkShade")]
        [String]
            $BorderFormat = "Double",

        [Switch]
            $NoNewLine
        )
    Function Change-UiSize {
        Param($MaxLength)
        if ($Host.Name -eq "ConsoleHost"){
            #only change if in a console
            $pshost = get-host
            $pswindow = $pshost.ui.rawui
            #Change BufferSize
            $Currentsize = $pswindow.buffersize
            if ($CurrentSize.Width -le $MaxLength){
                Write-Verbose "Changing Host Buffer size"
                $NewSize = $Currentsize
                $NewSize.width = $MaxLength
                $pswindow.buffersize = $NewSize
            }
            #Change WindowsSize
            $CurrentSize = $pswindow.windowsize
            if ($CurrentSize.Width -le $MaxLength){
                Write-Verbose "Changing Host Windows size"
                $NewSize = $Currentsize
                $NewSize.width = $MaxLength
                $pswindow.windowsize = $NewSize
            }
        }
    }
    Function Build-Border {
        Param([String]$BorderFormat,[Int]$Length)
        Function Get-BorderFormat {
            Param([String]$Format)

        Switch ($Format){
            "Single" {
                $TopLeft     = [char]0x250c
                $HLineTop    = [char]0x2500
                $TopRight    = [char]0x2510
                $VLineLeft   = [char]0x2502
                $VLineRight  = [char]0x2502
                $BottomLeft  = [char]0x2514
                $BottomRight = [char]0x2518
                $HLineBottom = [char]0x2500
            }
            "SingleBold" {
                $TopLeft     = [char]0x250f
                $HLine       = [char]0x2501
                $TopRight    = [char]0x2513
                $VLine       = [char]0x2503
                $BottomLeft  = [char]0x2517
                $BottomRight = [char]0x251b      
            }
            "Double" {
                $TopLeft     = [char]0x2554
                $HLineTop    = [char]0x2550
                $TopRight    = [char]0x2557
                $VLineLeft   = [char]0x2551
                $VLineRight  = [char]0x2551
                $BottomLeft  = [char]0x255a
                $BottomRight = [char]0x255d
                $HLineBottom = [char]0x2550          
            }
            "Mixed1" {
                $TopLeft     = [char]0x2552
                $HLineTop    = [char]0x2550
                $TopRight    = [char]0x2555
                $VLineLeft   = [char]0x2502
                $VLineRight  = [char]0x2502
                $BottomLeft  = [char]0x2558
                $BottomRight = [char]0x255b            
                $HLineBottom = [char]0x2550                
            }
            "Mixed2" {
                $TopLeft     = [char]0x2553
                $HLineTop    = [char]0x2500
                $TopRight    = [char]0x2556
                $VLineLeft   = [char]0x2551
                $VLineRight  = [char]0x2551
                $BottomLeft  = [char]0x2559
                $BottomRight = [char]0x255c
                $HLineBottom = [char]0x2500            
            }
            "HalfBlock" {
                $TopLeft     = [char]0x258c
                $HLineTop    = [char]0x2580
                $TopRight    = [char]0x2590
                $VLineLeft   = [char]0x258c
                $VLineRight  = [char]0x2590
                $BottomLeft  = [char]0x258c
                $BottomRight = [char]0x2590
                $HLineBottom = [char]0x2584            
            }
            "Block" {
                $TopLeft     = [char]0x2588
                $HLineTop    = [char]0x2588
                $TopRight    = [char]0x2588
                $VLineLeft   = [char]0x2588
                $VLineRight  = [char]0x2588
                $BottomLeft  = [char]0x2588
                $BottomRight = [char]0x2588
                $HLineBottom = [char]0x2588            
            }
            "LightShade" {
                $TopLeft     = [char]0x2591
                $HLineTop    = [char]0x2591
                $TopRight    = [char]0x2591
                $VLineLeft   = [char]0x2591
                $VLineRight  = [char]0x2591
                $BottomLeft  = [char]0x2591
                $BottomRight = [char]0x2591
                $HLineBottom = [char]0x2591            
            }
            "MediumShade" {
                $TopLeft     = [char]0x2592
                $HLineTop    = [char]0x2592
                $TopRight    = [char]0x2592
                $VLineLeft   = [char]0x2592
                $VLineRight  = [char]0x2592
                $BottomLeft  = [char]0x2592
                $BottomRight = [char]0x2592
                $HLineBottom = [char]0x2592            
            }
            "DarkShade" {
                $TopLeft     = [char]0x2593
                $HLineTop    = [char]0x2593
                $TopRight    = [char]0x2593
                $VLineLeft   = [char]0x2593
                $VLineRight  = [char]0x2593
                $BottomLeft  = [char]0x2593
                $BottomRight = [char]0x2593
                $HLineBottom = [char]0x2593            
            }
             Default {
                $TopLeft     = [char]0x2554
                $HLineTop    = [char]0x2550
                $TopRight    = [char]0x2557
                $VLineLeft   = [char]0x2551
                $VLineRight  = [char]0x2551
                $BottomLeft  = [char]0x255a
                $BottomRight = [char]0x255d
                $HLineBottom = [char]0x2550             
            }
        }
        $Borders = New-Object PSObject -Property @{
            TopLeft = $TopLeft
            HLineTop = $HLineTop
            TopRight = $TopRight
            VLineLeft = $VLineLeft
            VLineRight = $VLineRight
            BottomLeft = $BottomLeft
            BottomRight = $BottomRight
            HLineBottom = $HLineBottom
        }
        Write-Output $Borders
    }
        $LeadingSpace = 2
        $Borders = Get-BorderFormat -Format $BorderFormat
        $Borders = New-Object PSObject -Property @{
            TopLine = "$($Borders.TopLeft)$([String]$Borders.HLineTop * ($Length + $LeadingSpace))$($Borders.TopRight)"
            EmptyLine = "$($Borders.VLineLeft)$(" " * ($Length + $LeadingSpace))$($Borders.VLineRight)"
            BottomLine = "$($Borders.BottomLeft)$([String]$Borders.HLineBottom * ($Length + $LeadingSpace))$($Borders.BottomRight)"
            VlineLeft = $Borders.VLineLeft
            VLineRight = $Borders.VLineRight
        }
        Write-Output $Borders
    }
    Function Build-Content {
        Param($Message,$OpenChar,$CloseChar,$HideChar)
        Function Filter-OpenClose {
            Param([String]$Message,[Char]$OpenChar,[Char]$CloseChar)
            Function Find-AllChar {
                Param([String]$Message,[Char]$Char)
                $StringArray=$Message.Split($Char)
                $PosArray = @()
                $Pos = 0
                ForEach($String in $StringArray){
                    $Pos = $String.Length + $Pos
                    if ($Pos -lt ($Message.Length)) {
                        $PosArray += $Pos
                    }
                    $Pos = $Pos + 1
                }
                Write-Output $PosArray
            }
            #Find all char
            $OpenList = Find-AllChar -Message $Message -Char $OpenChar
            $CloseList = Find-AllChar -Message $Message -Char $CloseChar
            #Filter Open Close
            $NewOpened,$NewClosed = @(),@()
            
            if (($OpenList.Count -gt 0) -and ($CloseList.count -gt 0)){
                $OpenedCount,$ClosedCount,$TempClosedCount = 0,0,0
                for($i = 0;$i -le $CloseList[$CloseList.count - 1];$i ++){
                    if ($i -eq $OpenList[$OpenedCount]){
                        $OpenedCount ++
                        if ($OpenedCount -eq ($ClosedCount + 1)){
                            $NewOpened += $i
                        }
                    }
                    if ($i -eq $CloseList[$TempClosedCount]){
                        $TempClosedCount ++
                        if ($OpenedCount -gt $ClosedCount){
                            $ClosedCount ++
                            if ($ClosedCount -eq $OpenedCount){$NewClosed += $i}
                        }
                    }
                }
                Write-Output $NewOpened,$NewClosed
            }
        }
        $Lines,$LinesInfo= @(),@()
        $MaxLength = 0
        $Lines += $Message -split "\r\n"
        ForEach ($Line in $Lines) {
            #Getting Open and Close Position
            $OpenedList,$ClosedList = Filter-OpenClose -Message $Line -OpenChar $OpenChar -CloseChar $CloseChar
            if ($HideChar){
                #Remove char from line length
                $LineLength = $Line.Length - $OpenedList.Count - $ClosedList.Count 
            }Else{
                $LineLength = $Line.Length
            }
            $LineInfo = New-Object PSObject -Property @{
                Line = $Line
                OpenList = $OpenedList
                CloseList = $ClosedList
                LineLength = $LineLength
            }
            $LinesInfo += $LineInfo
            if ($LineLength -gt $MaxLength) {
                $MaxLength = $LineLength
            }
        }
        Write-Output $LinesInfo,$MaxLength
    }
    Function Write-Content {
        Param([PSObject]$Lines,[PSObject]$Borders,[ConsoleColor]$DefaultColor,[ConsoleColor]$AltColor,[ConsoleColor]$BorderColor,[Int32]$MaxLength,[Boolean]$HideChar,[Boolean]$NoNewLine)
        Function Write-Colored {
            Param($Line,$DefaultColor,$AltColor,$Align,$MaxLength,$HideChar)
            $Pos = 0
            $Index = 0
            [String]$MyString = $Line.Line
            if ($HideChar){
                $StringLen = $MyString.Length - $Line.OpenList.Count - $Line.CloseList.Count
            }Else{
                $StringLen = $MyString.Length
            }

            Switch ($Align){
                    "Center"{
                            if ($StringLen -lt $MaxLength) {
                                [Int32]$SpaceLenBefore = ($MaxLength - $StringLen) / 2
                                [Int32]$SpaceLenAfter = ($MaxLength - $StringLen - $SpaceLenBefore)
                                If ($SpaceLenBefore -gt 0){
                                    $SpaceBefore = " " * $SpaceLenBefore
                                }Else{
                                    $SpaceBefore = ""
                                }
                                if ($SpaceLenAfter -gt 0){
                                    $SpaceAfter = " " * $SpaceLenAfter
                                }Else{
                                    $SpaceAfter = ""
                                }
                            }
                        }
                    "Right" {
                            if ($StringLen -lt $MaxLength) {
                                [Int32]$SpaceLenBefore = ($MaxLength - $StringLen)
                                $SpaceAfter = ""
                                if ($SpaceLenBefore -gt 0){
                                    $SpaceBefore = " " * $SpaceLenBefore
                                }Else{
                                    $SpaceBefore = ""
                                }
                            }
                        }
                    "Left" {
                        if ($StringLen -lt $MaxLength) {
                                [Int32]$SpaceLenAfter = ($MaxLength - $StringLen)
                                $SpaceBefore = ""
                                if ($SpaceLenAfter -gt 0){
                                    $SpaceAfter = " " * $SpaceLenAfter
                                }Else{
                                    $SpaceAfter = ""
                                }                        
                        }
                    }
            }
            Write-Host $SpaceBefore -NoNewline
            if (($Line.OpenList.count -gt 0) -and ($line.CloseList.count -gt 0)) {
                Do {
                    if ($HideChar){
                        $StartDefaultColor = $Pos
                        $DefaultColorLen = $Line.OpenList[$Index] - $Pos
                        $StartAltColor = $Line.OpenList[$Index] + 1
                        $AltColorLen = ($Line.CloseList[$Index] - $Line.OpenList[$Index]) - 1
                    }Else{
                        $StartDefaultColor = $Pos
                        $DefaultColorLen = ($Line.OpenList[$Index] - $Pos) + 1

                        $StartAltColor = $Line.OpenList[$Index] + 1
                        $AltColorLen = ($Line.CloseList[$Index] - $Line.OpenList[$Index]) - 1
                    }
                    $DefaultColorMessage = $MyString.Substring($StartDefaultColor,$DefaultColorLen)
                    $AltColorMessage = $MyString.Substring($StartAltColor,$AltColorLen)

                    Write-Host $DefaultColorMessage -NoNewline -ForegroundColor $DefaultColor
                    Write-Host $AltColorMessage -NoNewline -ForegroundColor $AltColor
                    if ($HideChar){
                        $Pos = $Line.CloseList[$Index] + 1
                    }Else{
                        $Pos = $Line.CloseList[$Index]
                    }
                    $Index = $Index + 1
                    if ($Index -ge $Line.OpenList.Count){
                        if ($HideChar){
                            $StartDefaultColor = $Line.CloseList[$Index - 1] + 1
                            $DefaultColorLen = $MyString.Length - ($Line.CloseList[$Index - 1] + 1)
                        }Else{
                            $StartDefaultColor = $Line.CloseList[$Index - 1]
                            $DefaultColorLen = $MyString.Length - $Line.CloseList[$Index - 1]
                        }
                        $DefaultColorMessage = $MyString.SubString($StartDefaultColor,$DefaultColorLen)
                        Write-Host $DefaultColorMessage -NoNewline -ForegroundColor $DefaultColor
                        $ExitLoop = $True
                    }
                }
                Until ($ExitLoop)
            }Else{
                Write-Host $MyString -NoNewline -ForegroundColor $DefaultColor
            }
            Write-Host $SpaceAfter -NoNewline
        }
        if ($Borders){
            Write-Host "$($Borders.TopLine)" -ForegroundColor $BorderColor
            #Write-Host "$($Borders.EmptyLine)" -ForegroundColor $BorderColor
        }
        ForEach ($Line in $Lines){
            if ($Borders) {
                Write-Host "$($Borders.VLineLeft) " -ForegroundColor $BorderColor -NoNewline
            }
            Write-Colored -Line $Line -DefaultColor $DefaultColor -AltColor $AltColor -Align $Align -MaxLength $MaxLength -HideChar $HideChar
            if ($Borders) {
                Write-Host " $($Borders.VLineRight)" -ForegroundColor $BorderColor -NoNewline
            }
            if (-Not $NoNewLine){
                Write-Host $Null
            }
        }
        if ($Borders){
            #Write-Host "$($Borders.EmptyLine)" -ForegroundColor $BorderColor
            Write-Host "$($Borders.BottomLine)" -ForegroundColor $BorderColor
        }

    }
    $LinesInfo,$MaxLength = Build-Content -Message $Message -OpenChar $OpenChar -CloseChar $CloseChar -HideChar $HideChar
    Change-UiSize -MaxLength $($MaxLength + 4)
    if ($Border){
        $Borders = Build-Border -BorderFormat $BorderFormat -Length $MaxLength
    }
    Write-Content -Lines $LinesInfo -Borders $Borders -DefaultColor $DefaultColor -AltColor $AltColor -BorderColor $BorderColor -Align $Align -MaxLength $MaxLength -HideChar $HideChar -NoNewLine $NoNewLine

}
Function Add-ChoiceItem {
<#
    .SYNOPSIS
        Create / Update a choice Menu to be used with Write-ChoiceMenu
    .DESCRIPTION
        This function will create or update a choice menu that can be used with the Write-ChoiceMenu cmdlet
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -MenuItem "Get the process list" -MenuAction "Get-Process"
        Will Create a Menu then add a choice displayed as "Get the process list" and this choice will return "Get-Process"
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the time" -MenuAction "Get-Date -Format HH:mm:ss"
        Will add a choice to $ChoiceMenu displayed as "Get the time" and this choice will return "Get-Date -Format HH:mm:ss"
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the date" -MenuAction "Get-Date -Format dd.MM.yyyy"
        Will add a choice to $ChoiceMenu displayed as "Get the date" and this choice will return "Get-Date -Format dd.MM.yyyy"
    .PARAMETER Menu
        Existing menu to update
    .PARAMETER MenuItem
        Item to display in the menu
    .PARAMETER MenuAction
        Item to return when MenuItem is chosen
    .INPUTS
        System.String
    .OUTPUTS
        System.String
    .NOTES
        Written by Yann Girardet
    .FUNCTIONALITY
        To Make a Choice Menu
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    Param(
        [Array]
            $Menu,
        [Parameter(
            Mandatory=$True
        )]
        [String]
            $MenuItem,
        [String]
            $MenuAction=$MenuItem
        )
    if (-not $Menu){$Menu = @()}
    $ChoiceItem = New-Object PSObject -Property @{
        Item = $MenuItem
        Action = $MenuAction
    }
    $Menu += $ChoiceItem
    Write-Output $Menu
}
Function Write-ChoiceMenu {
<#
    .SYNOPSIS
        Display a Choice Menu
    .DESCRIPTION
        This function will display a Choice Menu
    .EXAMPLE
        $ReturnValue = Write-ChoiceMenu -Menu $ChoiceMenu -Title "My Menu"
        Will display a choice menu with "My Menu" as Title and $ChoiceMenu as content
    .PARAMETER Menu
        Content of the menu
    .PARAMETER Title
        Title of the choice list
    .INPUTS
        System.Array
    .OUTPUTS
        System.String
    .NOTES
        Written by Yann Girardet
    .FUNCTIONALITY
        To display a Choice Menu
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True
        )]
        [Array]
            $Menu,
        [ConsoleColor]
            $MenuColor = "Cyan",
        [ConsoleColor]
            $MenuAltColor = "Green",
        [ConsoleColor]
            $ChoiceColor = "Yellow",
        [String]
            $Title,
        [ValidateSet("None","Single","SingleBold","Double","Mixed1","Mixed2","HalfBlock","Block","LightShade","MediumShade","DarkShade")]
        [String]
            $TitleBorderFormat = "Double",
        [ConsoleColor]
            $TitleBorderColor = "Magenta",
        [ConsoleColor]
            $TitleColor = $MenuColor
        )
    if ($Menu -and $Menu.Count -gt 1){
        Do {
            if ($Title) {
                if ($TitleBorderStyle -eq "None"){
                    Write-Line -Message $Title -DefaultColor $TitleColor
                }Else{
                    Write-Line -Message $Title -Border -BorderFormat $TitleBorderFormat -BorderColor $TitleBorderColor -DefaultColor $TitleColor 
                }
            }
            Write-Host ""
            $MenuCounter = 1
            ForEach ($Choice in $Menu){
                Write-Line "`t$($MenuCounter))" -DefaultColor $ChoiceColor -NoNewLine
                Write-Line "`t$($Choice.Item)" -DefaultColor $MenuColor -AltColor $MenuAltColor
                $MenuCounter ++
            }
            Write-Host ""
            Write-Line "Please make your choice [1-$($Menu.Count)] or [Enter] to Exit" -NoNewLine -DefaultColor $MenuColor -AltColor $MenuAltColor
            $UserChoice = Read-Host " "
            Try{
                $UserChoice = [convert]::ToInt32($UserChoice)
            }
            Catch {}
            if ($UserChoice -eq "") {
                $RetVal = $Null
                $UserExited = $True
            }Elseif (($UserChoice -gt 0) -and ($UserChoice -le $($Menu.Count))){
                $RetVal = $($Menu.Action[$UserChoice - 1])
                $UserExited = $True
            }Else{
                Write-Host ""
                Write-Line "`t!! Error... [$($UserChoice)] is not a valid choice !!" -DefaultColor Yellow -AltColor RED
                Write-Host ""
            }
        }Until($UserExited)
    }Else{
        Throw "'Menu' must contain at least 2 entry... First use Add-ChoiceItem to Create a Menu"
    }
    Write-Output $RetVal
}
Function Read-Line {
<#
    .SYNOPSIS
        Display a question and wait user to answer using Read-Host
    .DESCRIPTION
        Display a question and wait user to type the authorized answer
    .EXAMPLE
        $ReturnValue = Read-Line -NoQuit
        Will display 'Continue [YES/NO] or [E] to Exit :'
    .EXAMPLE
        $ReturnValue = Read-Line -Message "Is it ok"
        Will display 'Is it ok, Continue [YES/NO] or [E] to Exit :'
    .PARAMETER Message
        Message displayed
    .PARAMETER NoQuit
        Default text will be '$Message Continue [YES/NO] :'
    .PARAMETER DefaultColor
        Specify default text color. Default 'Cyan'
    .PARAMETER AltColor
        Specify text between OpenChar and CloseChar color. Default 'Green'    
    .INPUTS
        System.Array
    .OUTPUTS
        System.Boolean
    .NOTES
        Written by Yann Girardet
    .FUNCTIONALITY
        To display a question to host
    .FORWARDHELPTARGETNAME <read-Host>
#>
    Param(
        [String]
            $Message,
        [Switch]
            $NoQuit,
        [ConsoleColor]
            $DefaultColor="Cyan",
        [ConsoleColor]
            $AltColor="Green"
    )
    Write-Verbose "Function : $($MyInvocation.MyCommand.Name)"
    Do {
        if ($Message){$Line = "$($Message), "}
        if ($NoQuit){
            $Line = "$($Line)Continue [YES/NO]"
        }Else{
            $Line = "$($Line)Continue [YES/NO] or [E] to Exit"
        }
        Write-Line $Line -NoNewLine -DefaultColor $DefaultColor -AltColor $AltColor
        [String]$Answer = Read-Host " "
        Write-Verbose "Answer is : [$($Answer)]"
        $LAnswer = $Answer.ToLower()
        Switch ($LAnswer){
            "yes" {
                $Ret_Val = $True
                $ValidChoice = $True
                }
            "y" {
                $Ret_Val = $True
                $ValidChoice = $True
                }
            "no" {
                $Ret_Val = $False
                $ValidChoice = $True
                }
            "n" {
                $Ret_Val = $False
                $ValidChoice = $True
                }
            "exit" {
                $Ret_Val = $null
                    if ($NoQuit){
                        Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                        $ValidChoice = $False
                    }Else{
                        $ValidChoice = $True
                    }
                }
            "e" {
                $Ret_Val = $null
                    if ($NoQuit){
                        Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                        $ValidChoice = $False
                    }Else{
                        $ValidChoice = $True
                    }
                }
            "quit" {
                $Ret_Val = $null
                    if ($NoQuit){
                        Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                        $ValidChoice = $False
                    }Else{
                        $ValidChoice = $True
                    }
                }
            "q" {
                $Ret_Val = $null
                    if ($NoQuit){
                        Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                        $ValidChoice = $False
                    }Else{
                        $ValidChoice = $True
                    }
                }
            default {
                Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                $ValidChoice = $False
            }
        }
    }Until($ValidChoice)
    Write-Output $Ret_Val
}