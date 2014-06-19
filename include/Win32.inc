;
; Commands to pass to WinHelp()
;
HELP_CONTEXT     = 0001h
HELP_QUIT        = 0002h
HELP_INDEX       = 0003h
HELP_CONTENTS    = 0003h
HELP_HELPONHELP  = 0004h
HELP_SETINDEX    = 0005h
HELP_SETCONTENTS = 0005h
HELP_CONTEXTPOPUP = 0008h
HELP_FORCEFILE   = 0009h
HELP_KEY         = 0101h
HELP_COMMAND     = 0102h
HELP_PARTIALKEY  = 0105h
HELP_MULTIKEY    = 0201h
HELP_SETWINPOS   = 0203h
HELP_CONTEXTMENU = 000ah
HELP_FINDER      = 000bh
HELP_WM_HELP     = 000ch
HELP_SETPOPUP_POS = 000dh

HELP_TCARD             = 8000h
HELP_TCARD_DATA        = 0010h
HELP_TCARD_OTHER_CALLER  = 0011h

IDH_NO_HELP                =     28440
IDH_MISSING_CONTEXT        =     28441
IDH_GENERIC_HELP_BUTTON    =     28442
IDH_OK                     =     28443
IDH_CANCEL                 =     28444
IDH_HELP                   =     28445
;*******************************************************************
;
;       OFSTRUCT
;
;*******************************************************************
OF_READ             = 00000000h
OF_WRITE            = 00000001h
OF_READWRITE        = 00000002h
OF_SHARE_COMPAT     = 00000000h
OF_SHARE_EXCLUSIVE  = 00000010h
OF_SHARE_DENY_WRITE = 00000020h
OF_SHARE_DENY_READ  = 00000030h
OF_SHARE_DENY_NONE  = 00000040h
OF_PARSE            = 00000100h
OF_DELETE           = 00000200h
OF_VERIFY           = 00000400h
OF_CANCEL           = 00000800h
OF_CREATE           = 00001000h
OF_PROMPT           = 00002000h
OF_EXIST            = 00004000h
OF_REOPEN           = 00008000h
OFS_MAXPATHNAME     = 128

OFN_READONLY              =   00000001h
OFN_OVERWRITEPROMPT       =   00000002h
OFN_HIDEREADONLY          =   00000004h
OFN_NOCHANGEDIR           =   00000008h
OFN_SHOWHELP              =   00000010h
OFN_ENABLEHOOK            =   00000020h
OFN_ENABLETEMPLATE        =   00000040h
OFN_ENABLETEMPLATEHANDLE  =   00000080h
OFN_NOVALIDATE            =   00000100h
OFN_ALLOWMULTISELECT      =   00000200h
OFN_EXTENSIONDIFFERENT    =   00000400h
OFN_PATHMUSTEXIST         =   00000800h
OFN_FILEMUSTEXIST         =   00001000h
OFN_CREATEPROMPT          =   00002000h
OFN_SHAREAWARE            =   00004000h
OFN_NOREADONLYRETURN      =   00008000h
OFN_NOTESTFILECREATE      =   00010000h
OFN_NONETWORKBUTTON       =   00020000h
OFN_NOLONGNAMES           =   00040000h
OFN_EXPLORER              =   00080000h
OFN_NODEREFERENCELINKS    =   00100000h
OFN_LONGNAMES             =   00200000h
OFN_SHAREFALLTHROUGH      =   2
OFN_SHARENOWARN           =   1
OFN_SHAREWARN             =   0

STD_CUT             =    0
STD_COPY            =    1
STD_PASTE           =    2
STD_UNDO            =    3
STD_REDOW           =    4
STD_DELETE          =    5
STD_FILENEW         =    6
STD_FILEOPEN        =    7
STD_FILESAVE        =    8
STD_PRINTPRE        =    9
STD_PROPERTIES      =    10
STD_HELP            =    11
STD_FIND            =    12
STD_REPLACE         =    13
STD_PRINT           =    14

TBSTATE_CHECKED       =  01h
TBSTATE_PRESSED       =  02h
TBSTATE_ENABLED       =  04h
TBSTATE_HIDDEN        =  08h
TBSTATE_INDETERMINATE =  10h
TBSTATE_WRAP          =  20h

TBSTYLE_BUTTON        =  00h
TBSTYLE_SEP           =  01h
TBSTYLE_CHECK         =  02h
TBSTYLE_GROUP         =  04h
TBSTYLE_CHECKGROUP    =  TBSTYLE_GROUP+TBSTYLE_CHECK

TBSTYLE_TOOLTIPS      =  0100h
TBSTYLE_WRAPABLE      =  0200h
TBSTYLE_ALTDRAG       =  0400h

TB_ENABLEBUTTON       =  (WM_USER + 1)
TB_CHECKBUTTON        =  (WM_USER + 2)
TB_PRESSBUTTON        =  (WM_USER + 3)
TB_HIDEBUTTON         =  (WM_USER + 4)
TB_INDETERMINATE      =  (WM_USER + 5)
TB_ISBUTTONENABLED    =  (WM_USER + 9)
TB_ISBUTTONCHECKED    =  (WM_USER + 10)
TB_ISBUTTONPRESSED    =  (WM_USER + 11)
TB_ISBUTTONHIDDEN     =  (WM_USER + 12)
TB_ISBUTTONINDETERMINATE = (WM_USER + 13)
TB_SETSTATE           =  (WM_USER + 17)
TB_GETSTATE           =  (WM_USER + 18)
TB_ADDBITMAP          =  (WM_USER + 19)
TB_SAVERESTOREA       =  (WM_USER + 26)
TB_SAVERESTOREW       =  (WM_USER + 76)
TB_CUSTOMIZE          =  (WM_USER + 27)
TB_ADDSTRINGA         =  (WM_USER + 28)
TB_ADDSTRINGW         =  (WM_USER + 77)
TB_GETITEMRECT        =  (WM_USER + 29)
TB_BUTTONSTRUCTSIZE   =  (WM_USER + 30)
TB_SETBUTTONSIZE      =  (WM_USER + 31)
TB_SETBITMAPSIZE      =  (WM_USER + 32)
TB_AUTOSIZE           =  (WM_USER + 33)
TB_GETTOOLTIPS        =  (WM_USER + 35)
TB_SETTOOLTIPS        =  (WM_USER + 36)
TB_SETPARENT          =  (WM_USER + 37)
TB_SETROWS            =  (WM_USER + 39)
TB_GETROWS            =  (WM_USER + 40)
TB_SETCMDID           =  (WM_USER + 42)
TB_CHANGEBITMAP       =  (WM_USER + 43)
TB_GETBITMAP          =  (WM_USER + 44)
TB_GETBUTTONTEXTA     =  (WM_USER + 45)
TB_GETBUTTONTEXTW     =  (WM_USER + 75)
TB_REPLACEBITMAP      =  (WM_USER + 46)

;====== COMMON CONTROL STYLES =====

CCS_TOP            =     00000001h
CCS_NOMOVEY        =     00000002h
CCS_BOTTOM         =     00000003h
CCS_NORESIZE       =     00000004h
CCS_NOPARENTALIGN  =     00000008h
CCS_ADJUSTABLE     =     00000020h
CCS_NODIVIDER      =     00000040h

TTN_NEEDTEXT equ 0FFFFFDF8h

RECT	struc
	rcLeft          dd ?
	rcTop           dd ?
	rcRight         dd ?
	rcBottom        dd ?
RECT	ends

;*******************************************************************
;
;  Window Class structure
;
;*******************************************************************

WNDCLASS struc
        clsStyle          dd     ?
        clsLpfnWndProc    dd    ?
        clsCbClsExtra     dd     ?
        clsCbWndExtra     dd     ?
        clsHInstance      dd     ?
        clsHIcon          dd     ?
        clsHCursor        dd     ?
        clsHbrBackground  dd     ?
        clsLpszMenuName   dd    ?
        clsLpszClassName  dd    ?
        hIconSm           dd     ?
WNDCLASS ends

PAINTSTRUCT STRUC
    PShdc         dd             ?
    PSfErase      dd             ?
    PSrcPaint     db            size RECT dup(?)
    PSfRestore    dd             ?
    PSfIncUpdate  dd             ?
    PSrgbReserved db            32 dup(?)
PAINTSTRUCT ENDS

MSGSTRUCT struc
    msHWND          dd    ?
    msMESSAGE       dd    ?
    msWPARAM        dd    ?
    msLPARAM        dd   ?
    msTIME          dd   ?
    msPT            dd   2 dup(?)
MSGSTRUCT ends

MINMAXINFO struc
  res_x               dd ?
  res_y               dd ?
  maxsize_x           dd ?
  maxsize_y           dd ?
  maxposition_x       dd ?
  maxposition_y       dd ?
  mintrackposition_x  dd ?
  mintrackposition_y  dd ?
  maxtrackposition_x  dd ?
  maxtrackposition_y  dd ?
MINMAXINFO ends
;
;   System Metrics
;
SM_CXSCREEN         =    0
SM_CYSCREEN         =    1
SM_CXVSCROLL        =    2
SM_CYHSCROLL        =    3
SM_CYCAPTION        =    4
SM_CXBORDER         =    5
SM_CYBORDER         =    6
SM_CXDLGFRAME       =    7
SM_CYDLGFRAME       =    8
SM_CYVTHUMB         =    9
SM_CXHTHUMB         =    10
SM_CXICON           =    11
SM_CYICON           =    12
SM_CXCURSOR         =    13
SM_CYCURSOR         =    14
SM_CYMENU           =    15
SM_CXFULLSCREEN     =    16
SM_CYFULLSCREEN     =    17
SM_CYKANJIWINDOW    =    18
SM_MOUSEPRESENT     =    19
SM_CYVSCROLL        =    20
SM_CXHSCROLL        =    21
SM_DEBUG            =    22
SM_SWAPBUTTON       =    23
SM_RESERVED1        =    24
SM_RESERVED2        =    25
SM_RESERVED3        =    26
SM_RESERVED4        =    27
SM_CXMIN            =    28
SM_CYMIN            =    29
SM_CXSIZE           =    30
SM_CYSIZE           =    31
SM_CXFRAME          =    32
SM_CYFRAME          =    33
SM_CXMINTRACK       =    34
SM_CYMINTRACK       =    35
SM_CXDOUBLECLK      =    36
SM_CYDOUBLECLK      =    37
SM_CXICONSPACING    =    38
SM_CYICONSPACING    =    39
SM_MENUDROPALIGNMENT =    40
SM_PENWINDOWS       =    41
SM_DBCSENABLED      =    42
SM_CMOUSEBUTTONS    =    43
SM_CXFIXEDFRAME     equ      <SM_CXDLGFRAME>
SM_CYFIXEDFRAME     equ      <SM_CYDLGFRAME>
SM_CXSIZEFRAME      equ      <SM_CXFRAME>
SM_CYSIZEFRAME      equ      <SM_CYFRAME>
SM_SECURE           =    44
SM_CXEDGE           =    45
SM_CYEDGE           =    46
SM_CXMINSPACING     =    47
SM_CYMINSPACING     =    48
SM_CXSMICON         =    49
SM_CYSMICON         =    50
SM_CYSMCAPTION      =    51
SM_CXSMSIZE         =    52
SM_CYSMSIZE         =    53
SM_CXMENUSIZE       =    54
SM_CYMENUSIZE       =    55
SM_ARRANGE          =    56
SM_CXMINIMIZED      =    57
SM_CYMINIMIZED      =    58
SM_CXMAXTRACK       =    59
SM_CYMAXTRACK       =    60
SM_CXMAXIMIZED      =    61
SM_CYMAXIMIZED      =    62
SM_NETWORK          =    63
SM_CLEANBOOT        =    67
SM_CXDRAG           =    68
SM_CYDRAG           =    69
SM_SHOWSOUNDS       =    70
SM_CXMENUCHECK      =    71
SM_CYMENUCHECK      =    72
SM_SLOWMACHINE      =    73
SM_MIDEASTENABLED   =    74
SM_CMETRICS         =    75
;
;  Stock Logical Objects
;
WHITE_BRUSH         =  0
LTGRAY_BRUSH        =  1
GRAY_BRUSH          =  2
DKGRAY_BRUSH        =  3
BLACK_BRUSH         =  4
NULL_BRUSH          =  5
HOLLOW_BRUSH        =  5
WHITE_PEN           =  6
BLACK_PEN           =  7
NULL_PEN            =  8
DOT_MARKER          =  9
OEM_FIXED_FONT      = 10
ANSI_FIXED_FONT     = 11
ANSI_VAR_FONT       = 12
SYSTEM_FONT         = 13
DEVICE_DEFAULT_FONT = 14
DEFAULT_PALETTE     = 15
SYSTEM_FIXED_FONT   = 16

;
; Brush Styles
;
BS_SOLID        =   0
BS_NULL         =   1
BS_HOLLOW       =   BS_NULL
BS_HATCHED      =   2
BS_PATTERN      =   3
BS_INDEXED      =   4
BS_DIBPATTERN   =   5
;
; Hatch Styles
;
HS_HORIZONTAL   =   0       ; -----
HS_VERTICAL     =   1       ; |||||
HS_FDIAGONAL    =   2       ; \\\\\
HS_BDIAGONAL    =   3       ; /////
HS_CROSS        =   4       ; +++++
HS_DIAGCROSS    =   5       ; xxxxx
;
; Pen Styles
;
PS_SOLID        =   0
PS_DASH         =   1       ; -------
PS_DOT          =   2       ; .......
PS_DASHDOT      =   3       ; _._._._
PS_DASHDOTDOT   =   4       ; _.._.._
PS_NULL         =   5
PS_INSIDEFRAME  =   6

;
;  Window State Messages
;
WM_STATE            = 0

WM_NULL             = 0
WM_CREATE           = 1
WM_DESTROY          = 2
WM_MOVE             = 3
WM_SIZE             = 5
WM_ACTIVATE         = 6
WM_SETFOCUS         = 7
WM_KILLFOCUS        = 8
WM_ENABLE           = 0Ah
WM_SETREDRAW        = 0Bh
WM_SETTEXT          = 0Ch
WM_GETTEXT          = 0Dh
WM_GETTEXTLENGTH    = 0Eh
WM_PAINT            = 0Fh
WM_CLOSE            = 10h
WM_QUERYENDSESSION  = 11h
WM_QUIT             = 12h
WM_QUERYOPEN        = 13h
WM_ERASEBKGND       = 14h
WM_SYSCOLORCHANGE   = 15h
WM_ENDSESSION       = 16h
WM_SYSTEMERROR      = 17h
WM_SHOWWINDOW       = 18h
WM_CTLCOLOR         = 19h
WM_WININICHANGE     = 1Ah
WM_DEVMODECHANGE    = 1Bh
WM_ACTIVATEAPP      = 1Ch
WM_FONTCHANGE       = 1Dh
WM_TIMECHANGE       = 1Eh
WM_CANCELMODE       = 1Fh
WM_SETCURSOR        = 20h
WM_MOUSEACTIVATE    = 21h
WM_CHILDACTIVATE    = 22h
WM_QUEUESYNC        = 23h
WM_GETMINMAXINFO    = 24h
WM_PAINTICON        = 26h
WM_ICONERASEBKGND   = 27h
WM_NEXTDLGCTL       = 28h
WM_SPOOLERSTATUS    = 2Ah
WM_DRAWITEM         = 2Bh
WM_MEASUREITEM      = 2Ch
WM_DELETEITEM       = 2Dh
WM_VKEYTOITEM       = 2Eh
WM_CHARTOITEM       = 2Fh
WM_SETFONT          = 30h
WM_GETFONT          = 31h
WM_QUERYDRAGICON    = 37h
WM_COMPAREITEM      = 39h
WM_COMPACTING       = 41h
WM_COMMNOTIFY       = 44h
WM_WINDOWPOSCHANGING= 46h
WM_WINDOWPOSCHANGED = 47h
WM_POWER            = 48h
WM_NOTIFY           = 4Eh

WM_GETICON		= 7Fh
WM_SETICON		= 80h

WM_NCCREATE         = 81h
WM_NCDESTROY        = 82h
WM_NCCALCSIZE       = 83h
WM_NCHITTEST        = 84h
WM_NCPAINT          = 85h
WM_NCACTIVATE       = 86h
WM_GETDLGCODE       = 87h
WM_NCMOUSEMOVE      = 0A0h
WM_NCLBUTTONDOWN    = 0A1h
WM_NCLBUTTONUP      = 0A2h
WM_NCLBUTTONDBLCLK  = 0A3h
WM_NCRBUTTONDOWN    = 0A4h
WM_NCRBUTTONUP      = 0A5h
WM_NCRBUTTONDBLCLK  = 0A6h
WM_NCMBUTTONDOWN    = 0A7h
WM_NCMBUTTONUP      = 0A8h
WM_NCMBUTTONDBLCLK  = 0A9h

WM_KEYFIRST         = 100h
WM_KEYDOWN          = 100h
WM_KEYUP            = 101h
WM_CHAR             = 102h
WM_DEADCHAR         = 103h
WM_SYSKEYDOWN       = 104h
WM_SYSKEYUP         = 105h
WM_SYSCHAR          = 106h
WM_SYSDEADCHAR      = 107h
WM_KEYLAST          = 108h

WM_INITDIALOG       = 110h
WM_COMMAND          = 111h
WM_SYSCOMMAND       = 112h
WM_TIMER            = 113h
WM_HSCROLL          = 114h
WM_VSCROLL          = 115h
WM_INITMENU         = 116h
WM_INITMENUPOPUP    = 117h
WM_MENUSELECT       = 11Fh
WM_MENUCHAR         = 120h
WM_ENTERIDLE        = 121h

WM_MOUSEFIRST       = 200h
WM_MOUSEMOVE        = 200h
WM_LBUTTONDOWN      = 201h
WM_LBUTTONUP        = 202h
WM_LBUTTONDBLCLK    = 203h
WM_RBUTTONDOWN      = 204h
WM_RBUTTONUP        = 205h
WM_RBUTTONDBLCLK    = 206h
WM_MBUTTONDOWN      = 207h
WM_MBUTTONUP        = 208h
WM_MBUTTONDBLCLK    = 209h
WM_MOUSELAST        = 209h

WM_PARENTNOTIFY     = 210h

WM_SIZING		= 214h
WM_CAPTURECHANGED	= 215h
WM_MOVING		= 216h

WM_MDICREATE        = 220h
WM_MDIDESTROY       = 221h
WM_MDIACTIVATE      = 222h
WM_MDIRESTORE       = 223h
WM_MDINEXT          = 224h
WM_MDIMAXIMIZE      = 225h
WM_MDITILE          = 226h
WM_MDICASCADE       = 227h
WM_MDIICONARRANGE   = 228h
WM_MDIGETACTIVE     = 229h
WM_MDISETMENU       = 230h
WM_DROPFILES        = 233h

WM_CUT              = 300h
WM_COPY             = 301h
WM_PASTE            = 302h
WM_CLEAR            = 303h
WM_UNDO             = 304h
WM_RENDERFORMAT     = 305h
WM_RENDERALLFORMATS = 306h
WM_DESTROYCLIPBOARD = 307h
WM_DRAWCLIPBOARD    = 308h
WM_PAINTCLIPBOARD   = 309h
WM_VSCROLLCLIPBOARD = 30Ah
WM_SIZECLIPBOARD    = 30Bh
WM_ASKCBFORMATNAME  = 30Ch
WM_CHANGECBCHAIN    = 30Dh
WM_HSCROLLCLIPBOARD = 30Eh
WM_QUERYNEWPALETTE  = 30Fh
WM_PALETTEISCHANGING = 310h
WM_PALETTECHANGED   = 311h

WM_PENWINFIRST      equ 0380h
WM_PENWINLAST       equ 038Fh

WM_COALESCE_FIRST  equ 0390h
WM_COALESCE_LAST   equ 039Fh

;  private window messages start here
WM_USER		= 0400H

; WM_MOUSEACTIVATE Return Codes
MA_ACTIVATE       =  1
MA_ACTIVATEANDEAT =  2
MA_NOACTIVATE     =  3

; Size message commands
SIZENORMAL       = 0
SIZEICONIC       = 1
SIZEFULLSCREEN   = 2
SIZEZOOMSHOW     = 3
SIZEZOOMHIDE     = 4

; ShowWindow() Commands
SW_HIDE            = 0
SW_SHOWNORMAL      = 1
SW_NORMAL          = 1
SW_SHOWMINIMIZED   = 2
SW_SHOWMAXIMIZED   = 3
SW_MAXIMIZE        = 3
SW_SHOWNOACTIVATE  = 4
SW_SHOW            = 5
SW_MINIMIZE        = 6
SW_SHOWMINNOACTIVE = 7
SW_SHOWNA          = 8
SW_RESTORE         = 9

; Old ShowWindow() Commands
HIDE_WINDOW        = 0
SHOW_OPENWINDOW    = 1
SHOW_ICONWINDOW    = 2
SHOW_FULLSCREEN    = 3
SHOW_OPENNOACTIVATE= 4

;  identifiers for the WM_SHOWWINDOW message
SW_PARENTCLOSING =  1
SW_OTHERZOOM     =  2
SW_PARENTOPENING =  3
SW_OTHERUNZOOM   =  4

; Key state masks for mouse messages

MK_LBUTTON	= 1
MK_RBUTTON	= 2
MK_SHIFT	= 4
MK_CONTROL	= 8
MK_MBUTTON	= 10h

; Class styles

CS_VREDRAW		= 1
CS_HREDRAW		= 2
CS_DBLCLKS		= 8
CS_OWNDC		= 20h
CS_CLASSDC		= 40h
CS_PARENTDC		= 80h
CS_NOCLOSE		= 200h
CS_SAVEBITS		= 800h
CS_BYTEALIGNCLIENT	= 1000h
CS_BYTEALIGNWINDOW	= 2000h
CS_GLOBALCLASS		= 4000h

;
; Special CreateWindow position value
;
CW_USEDEFAULT	= 80000000h

;
; Windows styles
;
WS_OVERLAPPED   = 000000000h
WS_ICONICPOPUP  = 0C0000000h
WS_POPUP        = 080000000h
WS_CHILD        = 040000000h
WS_MINIMIZE     = 020000000h
WS_VISIBLE      = 010000000h
WS_DISABLED     = 008000000h
WS_CLIPSIBLINGS = 004000000h
WS_CLIPCHILDREN = 002000000h
WS_MAXIMIZE     = 001000000h
WS_CAPTION      = 000C00000h     ; WS_BORDER | WS_DLGFRAME
WS_BORDER       = 000800000h
WS_DLGFRAME     = 000400000h
WS_VSCROLL      = 000200000h
WS_HSCROLL      = 000100000h
WS_SYSMENU      = 000080000h
WS_THICKFRAME   = 000040000h
WS_HREDRAW      = 000020000h
WS_VREDRAW      = 000010000h
WS_GROUP        = 000020000h
WS_TABSTOP      = 000010000h
WS_MINIMIZEBOX  = 000020000h
WS_MAXIMIZEBOX  = 000010000h
WS_EX_CLIENTEDGE= 200h

; Common Window Styles

WS_OVERLAPPEDWINDOW = WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
WS_POPUPWINDOW  = WS_POPUP OR WS_BORDER OR WS_SYSMENU
WS_CHILDWINDOW  = WS_CHILD
WS_TILEDWINDOW  = WS_OVERLAPPEDWINDOW

WS_TILED        = WS_OVERLAPPED
WS_ICONIC       = WS_MINIMIZE
WS_SIZEBOX      = WS_THICKFRAME

; Extended Window Styles (low words)
WS_EX_DLGMODALFRAME	= 1
WS_EX_DRAGOBJECT	= 2
WS_EX_NOPARENTNOTIFY	= 4
WS_EX_TOPMOST		= 8

; PeekMessage() Options
PM_NOREMOVE	equ 0
PM_REMOVE	equ 1
PM_NOYIELD	equ 2

; SetWindowPos Flags
SWP_NOSIZE	equ 1
SWP_NOMOVE	equ 2
SWP_NOZORDER	equ 4
SWP_NOREDRAW	equ 8
SWP_NOACTIVATE	equ 10h
SWP_DRAWFRAME	equ 20h
SWP_SHOWWINDOW	equ 40h
SWP_HIDEWINDOW	equ 80h
SWP_NOCOPYBITS	equ 100h
SWP_NOREPOSITION	equ 200h
;
;  Predefined cursor & icon IDs
;
IDC_ARROW	equ 32512
IDC_IBEAM	equ 32513
IDC_WAIT	equ 32514
IDC_CROSS	equ 32515
IDC_UPARROW	equ 32516
IDC_SIZE	equ 32640
IDC_ICON	equ 32641
IDC_SIZENWSE	equ 32642
IDC_SIZENESW	equ 32643
IDC_SIZEWE	equ 32644
IDC_SIZENS	equ 32645

IDI_APPLICATION	equ 32512
IDI_HAND	equ 32513
IDI_QUESTION	equ 32514
IDI_EXCLAMATION	equ 32515
IDI_ASTERISK	equ 32516

COLOR_SCROLLBAR           = 0
COLOR_BACKGROUND          = 1
COLOR_ACTIVECAPTION       = 2
COLOR_INACTIVECAPTION     = 3
COLOR_MENU                = 4
COLOR_WINDOW              = 5
COLOR_WINDOWFRAME         = 6
COLOR_MENUTEXT            = 7
COLOR_WINDOWTEXT          = 8
COLOR_CAPTIONTEXT         = 9
COLOR_ACTIVEBORDER        = 10
COLOR_INACTIVEBORDER      = 11
COLOR_APPWORKSPACE        = 12
COLOR_HIGHLIGHT           = 13
COLOR_HIGHLIGHTTEXT       = 14
COLOR_BTNFACE             = 15
COLOR_BTNSHADOW           = 16
COLOR_GRAYTEXT            = 17
COLOR_BTNTEXT             = 18

;
;  MessageBox type flags
;
MB_OK                   = 0000H
MB_OKCANCEL             = 0001H
MB_ABORTRETRYIGNORE     = 0002H
MB_YESNOCANCEL          = 0003H
MB_YESNO                = 0004H
MB_RETRYCANCEL          = 0005H

MB_ICONHAND             = 0010H
MB_ICONQUESTION         = 0020H
MB_ICONEXCLAMATION      = 0030H
MB_ICONWARNING		= 0030H
MB_ICONASTERISK         = 0040H

MB_DEFBUTTON1           = 0000H
MB_DEFBUTTON2           = 0100H
MB_DEFBUTTON3           = 0200H

MB_APPLMODAL            = 0000H
MB_SYSTEMMODAL          = 1000H
MB_TASKMODAL            = 2000H

MB_NOFOCUS              = 8000H

;
;  Conventional dialog box and message box command IDs
;
IDOK		= 1
IDCANCEL	= 2
IDABORT		= 3
IDRETRY		= 4
IDIGNORE	= 5
IDYES		= 6
IDNO		= 7


;
;  Edit Control Messages
;
EM_GETSEL             =  00B0h
EM_SETSEL             =  00B1h
EM_GETRECT            =  00B2h
EM_SETRECT            =  00B3h
EM_SETRECTNP          =  00B4h
EM_SCROLL             =  00B5h
EM_LINESCROLL         =  00B6h
EM_SCROLLCARET        =  00B7h
EM_GETMODIFY          =  00B8h
EM_SETMODIFY          =  00B9h
EM_GETLINECOUNT       =  00BAh
EM_LINEINDEX          =  00BBh
EM_SETHANDLE          =  00BCh
EM_GETHANDLE          =  00BDh
EM_GETTHUMB           =  00BEh
EM_LINELENGTH         =  00C1h
EM_REPLACESEL         =  00C2h
EM_GETLINE            =  00C4h
EM_LIMITTEXT          =  00C5h
EM_CANUNDO            =  00C6h
EM_UNDO               =  00C7h
EM_FMTLINES           =  00C8h
EM_LINEFROMCHAR       =  00C9h
EM_SETTABSTOPS        =  00CBh
EM_SETPASSWORDCHAR    =  00CCh
EM_EMPTYUNDOBUFFER    =  00CDh
EM_GETFIRSTVISIBLELINE=  00CEh
EM_SETREADONLY        =  00CFh
EM_SETWORDBREAKPROC   =  00D0h
EM_GETWORDBREAKPROC   =  00D1h
EM_GETPASSWORDCHAR    =  00D2h
EM_SETMARGINS         =  00D3h
EM_GETMARGINS         =  00D4h
EM_SETLIMITTEXT       equ  <EM_LIMITTEXT>
EM_GETLIMITTEXT       =  00D5h
EM_POSFROMCHAR        =  00D6h
EM_CHARFROMPOS        =  00D7h

MF_UNCHECKED		= 0
MF_CHECKED		= 8
;----------------------------------------------------------------------
ES_LEFT			equ 0
ES_AUTOHSCROLL		equ 80h
ES_AUTOVSCROLL		equ 40h
ES_MULTILINE		equ 4

GENERIC_READ		equ 80000000h
GENERIC_WRITE		equ 40000000h
GENERIC_EXECUTE		equ 20000000h
GENERIC_ALL		equ 10000000h

CREATE_NEW		equ 1
CREATE_ALWAYS		equ 2
OPEN_EXISTING		equ 3
OPEN_ALWAYS		equ 4
TRUNCATE_EXISTING	equ 5

FILE_BEGIN		equ 0
FILE_SHARE_READ 	equ 1
FILE_SHARE_WRITE 	equ 2
FILE_ATTRIBUTE_ARCHIVE	equ 20h
FILE_ATTRIBUTE_NORMAL	equ 80h

FILE_FLAG_WRITE_THROUGH		equ 80000000h
FILE_FLAG_OVERLAPPED		equ 40000000h
FILE_FLAG_NO_BUFFERING		equ 20000000h
FILE_FLAG_RANDOM_ACCESS		equ 10000000h
FILE_FLAG_SEQUENTIAL_SCAN	equ 8000000h
FILE_FLAG_DELETE_ON_CLOSE	equ 4000000h

GMEM_MOVEABLE		equ 2
GMEM_ZEROINIT		equ 40h
GMEM_SHARE		equ 2000h
GMEM_DDESHARE		equ 2000h

PAGE_NOACCESS		equ 1
PAGE_READONLY		equ 2
PAGE_READWRITE		equ 4
PAGE_WRITECOPY		equ 8
PAGE_EXECUTE		equ 10h
PAGE_EXECUTE_READ	equ 20h
PAGE_EXECUTE_READWRITE	equ 40h
PAGE_EXECUTE_WRITECOPY	equ 80h
PAGE_GUARD		equ 100h
PAGE_NOCACHE		equ 200h
PAGE_WRITECOMBINE	equ 400h

FILE_MAP_COPY		equ 1		; SECTION_QUERY
FILE_MAP_WRITE		equ 2		; SECTION_MAP_WRITE
FILE_MAP_READ		equ 4		; SECTION_MAP_READ
FILE_MAP_ALL_ACCESS	equ 0F001Fh	; SECTION_ALL_ACCESS

PROCESS_VM_READ			equ 10h  
PROCESS_QUERY_INFORMATION	equ 400h  
PROCESS_ALL_ACCESS		equ 1F0FFFh

HWND_TOPMOST		equ -1

DUPLICATE_CLOSE_SOURCE	equ 1  
DUPLICATE_SAME_ACCESS	equ 2

SS_LEFT			= 0
SS_CENTER		= 1
SS_NOPREFIX		= 80h    ; Don't do "&" character translation

DWL_MSGRESULT	= 0
DWL_DLGPROC	= 4
DWL_USER	= 8
