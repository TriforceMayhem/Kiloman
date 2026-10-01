pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--kiloman level editor

function _init()
	--persistent palette changes
	?"⁶!5f2e¹"
	--disable btnp repeat
	--?"⁶!5f5c◝"
	--enable mouse
	?"⁶!5f2d¹"
	
	crep={
		[0]="\\0",
		[10]="\\n",
		[13]="\\r",
		[34]="\\\"",
		[92]="\\\\"
	}
	
	mx=0
	my=0
	mspr=1
	lmb=0
	rmb=0
	lvbyt=0
	
	elseg=1
	elmid=7
	
	elcsel=0
	elcof=0
	
	elx=0
	elxp=0
	elyp=0
	elxpo=0
	elypo=0
	elallow=true
	elflp=1
	elbg={}
	elcwork={}
	elfwork={}
	elcl=0
	elcr=0
	elpsel=false
	elpitl=false
	elpitr=false
	elfx=false
	
	elesel=0
	elexp=0
	elework={{},{},{},{},{},{},{},{},{}}
	elexplim={
		{1,4}, --spawners
		{3,7}, --items
		{1,6}, --yoku blocks
		{1,13}, --boss doors
		{1,5}, --w-plates
		{1,2}, --surge arcs
		{1,1}, --checkpoints
		{1,5}, --bosses
		{0}, --wily
	}
	eledrw={
		function(x,y,n)
			local ndrw={
				function(x,y)
					spr(154,x,y+3,2,1,true)
					spr(138,x,y-3,2,1,true)
				end,
				function(x,y)
					spr(140,x,y-8,2,2,true)
				end,
				function(x,y)
					spr(10,x+4,y-7,1,2)
					spr(8,x,y-23,2,2)
				end,
				function(x,y)
					spr(22,x,y+1,2,1)
				end,
			}
			ndrw[n](x,y)
		end,
		function(x,y,n)
			local xt,yt={-1,-1,1,0,1,0,0},{-1,-1,2,2,2,0,0}
			spr(n,x+xt[n],y+yt[n])
		end,
		function(x,y,n)
			spr(252,x,y)
			print(7-n,x+2,y+1,7)
		end,
		function(x,y,n)
			for i=1,n do
				spr(236,x,y+i*8)
				spr(236,x+8,y+i*8)
			end
		end,
		function(x,y,n)
			pal(12,split"9,6,14,14,12,9"[n])
			pal(13,split"4,12,1,8,1,0"[n])
			pal(1,split"1,13,0,2,0,1"[n])
			spr(170,x,y,2,2)
		end,
		function(x,y,n)
			color(26-n*11)
			local yf=2-(n%2)*4
			line(x+3,y+3,x+7,y+3+yf)
			line(x+7,y+3+yf,x+8,y+3-yf)
			line(x+8,y+3-yf,x+12,y+3)
		end,
		function(x,y,n)
			spr(172,x,y,2,2)
			local yp=104
			while fget(mget(x/8+7,yp/8))>=0x42 or fget(mget(x/8+8,yp/8))>=0x42 do
				yp-=8
			end
			spr(96,x+56,yp-8,2,2)
		end,
		function(x,y,n)
			local xpos=fdiv(x,128)*128+96
			if n<5 then
				pal(10,14)
				spr(126+n*2,xpos,y-15,2,2,true)
			else
				spr(34,xpos+4,y-12,1,1,true)
				circ(xpos+8,y-8,16,12)
				pset(xpos-1,y-17,7)
			end
			pal()
			palt"0"
			spr(158+n*2,x,y,2,2)
		end,
		function(x,y,n)
			spr(174,x,y-16,2,2)
		end,
	}
	
	ecclm=0
	ectlc=0
	ectls=0
	eccwork={}
	tst={}
	ecscr=0
	ecdragclm=false
	ecdragtst=false
	ecclmx=8
	ectstx=48
	
	msgtxt=""
	msgy=128
	msgtime=0
	
	_upd=elupdate
	_drw=eldraw
	
	tileinit()
	clminit()
	loadseg(elseg)
	
	menuitem(1,"total bytes",function() byttl() end)
	menuitem(2,"export tiles",function() xptile() end)
	menuitem(3,"unused tiles",function() unutile() end)
end

function _update60()
	--mouse
	mspr=1
	mx=stat(32)
	my=stat(33)
	--lmb
	if stat(34)&1==1 then
		lmb=(lmb<1) and 2 or 1
	else
		lmb=(lmb>0) and -1 or 0
	end
	--rmb
	if stat(34)>>1&1==1 then
		rmb=(rmb<1) and 2 or 1
	else
		rmb=(rmb>0) and -1 or 0
	end
	
	_upd()
end

function _draw()
	_drw()
	
	spr(mspr,mx-1,my-1)
	
	if msgtime>0 then
		msgy=max(msgy-0.75,121)
		msgtime-=1
	else
		msgy=min(msgy+0.75,128)
	end
	rectfill(0,msgy,127,128,11)
	print(msgtxt,1,msgy+1,3)
	
	pal(split"1,2,131,4,5,6,7,136,9,10,139,12,140,143",1)
end

function hud()
	memset(0x6000,187,512)
	memset(0x7e40,187,512)
end
-->8
--helpers
function fdiv(a,b)
	return flr(a/b)
end

function sqdx(v,p)
	return (v%p)*sgn(p),fdiv(v,p)
end

function spal(s)
	pal(split(s))
end

function chrrep(c)
	if crep[c] then
		lvbyt-=1
		return crep[c]
	end
	return chr(c)
end

function buildstr(tbl)
	local rstr=""
	local zchk=false
	for i=1,#tbl do
		if zchk and tbl[i]>=48 and tbl[i]<=57 then
			rstr..="00"
		end
		rstr..=chrrep(tbl[i]) or chr(tbl[i])
		zchk=tbl[i]==0
	end
	return rstr
end

function printd(t,x,y)
	for pos=0,3 do
		print(t,x+pos%2,y+pos/2,5)
	end
	print(t,x,y,6)
end

function buildrle(tbl)
	local rstr=""
	local oldch=tbl[1]
	local rcnt=0
	local zchk=false
	for i=1,#tbl do
		if tbl[i]==oldch then
			rcnt+=1
		else
			if rcnt>1 then
				rstr..=chr(224+rcnt)
				rcnt=1
			elseif zchk and oldch>=48 and oldch<=57 then
				rstr..="00"
				lvbyt-=2
			end
			rstr..=chrrep(oldch) or chr(oldch)
		end
		zchk=oldch==0
		oldch=tbl[i]
	end
	
	if rcnt>1 then
		rstr..=chr(224+rcnt)
		rcnt=1
	elseif zchk and oldch>=48 and oldch<=57 then
		rstr..="00"
		lvbyt-=2
	end
	rstr..=chrrep(oldch) or chr(oldch)
	
	return rstr
end

function pruneclm()
	local go=true
	while go do
		for i=#eccwork-6,#eccwork do
			go=(go and eccwork[i]==1)
		end
		if go then
			for i=1,7 do
				deli(eccwork)
			end
		end
	end
	ecclm=min(ecclm,#eccwork/7-1)
end

function fluffclm()
	while #eccwork/7<256 do
		for i=#eccwork%7+1,7 do
			add(eccwork,1)
		end
	end
end

function bcount(str)
	local idx=1
	local ch=ord(str[idx])
	local ptme=""
	while ch do
		lvbyt+=1
		idx+=1
		ptme..=ch.." "
		ch=ord(str[idx])
	end
	--printh(ptme,"@clip")
	return str
end

function byttl()
	lvbyt=0
	for i=1,#segments do
		bcount(segments[i])
	end
	msgtxt="all segments total: "..lvbyt+#segments.." bytes"
	msgtime=120
end

function xptile()
	local tlx=""
	for i=1,#tst do
		tlx..=tst[i]..(i==#tst and "" or ",")
	end
	printh(tlx,"@clip")
	msgtxt="exported tileset list"
	msgtime=120
end

function unutile()
	local unsd={}
	for i=192,255 do
		add(unsd,i)
	end
	for i=0,#tst do
		del(unsd,tst[i])
	end
	local utx=""
	for i=1,#unsd do
		utx..=unsd[i]..","
	end
	printh(utx,"@clip")
	msgtxt="copied unused tile list"
	msgtime=120
end
-->8
--level data

--goes by 2 to index metatiles
columns="\0\0\0\0\0\0\0²²²²²²²⁴⁴⁴⁴⁴⁴⁴⁶⁶⁶⁶⁶⁶⁶ᶜᵉ▮▮▮▮▮▮▮▮▮▮▮▮□□□□□□□◀「「⁘⁘⁘⁘、゛゛゛゛゛゛ \"\"\"\"\"\"¥¥¥¥¥¥¥:::::::=:::::?GGGGGGG;=::=;;999==99ACEEEAC:::?⁴⁴=::::=:?PJJJJJJJJJJJJLSPJJJJJU777777W\"\"LLLLYJJJKN¥IJJJMII\n¥¥¥¥¥¥\\\\\\\\\\\\\\e[[[[[if\\\\\\\\\\jg]]]]]kSf\\\\\\□ja]]]]]]`[[[[[[]]]]]]][[[[[[[\\\\\\\\y]]z((((((mf\\\\\\\\\\mmf\\\\\\\\Sg]]]]]{[^^^^}5777777ZZ]ZZZZupppppwu⁸⁸⁸⁸⁸uSupppppsupppwLpppppppsu⁸⁸w⁘██□█pupw█□Suppp█⁘Suppp🐱pppppjm🐱ppppj777🐱pppoou⁸poos⁸⁸⁸pqq2444444░²²²²²²😐🅾️🅾️🅾️🅾️🅾️…///////444⁴⁴⁴⁴&²²²²²²●^^^^^i♥さささささj☉ZZZZZk{iさささ{idkさささdk🅾️🅾️🅾️🅾️🅾️🅾️🅾️Sjさ/さj♥\n⁶⁶⁶⁶⁶お▤/////*▥/////,$$$$$$$&$$$$$+★★★★★★★⧗⧗⧗⧗⧗⧗⧗ˇˇˇˇˇˇˇ∧∧∧∧∧∧∧s😐🅾️🅾️🅾️🅾️🅾️/////*う/////,い"

--level segments
segments={
	--wily stage v2
	"ろ⁶:モナFGJヒ♥IJ⌂ゅヌナゃ웃IGH◝ヌナノ▒ヌ🐱ヌbノgヌ\")HFヌGHF*)GHFHFG*⁸J(ヌ😐FH◝ヨ⬆️Dく▮ね¥⬇️。ルD?D゜D/ヲね'の7",
	"ノ⁷:⁸)(ヌl⁶⁸◝ナヌbヌlb*\"◝ヨ#H★K",
	"\0¹¹\0ハ⁸:ナヌcヌ😐#😐²ハ⬇️ヌB³◝ヌ\"ネ😐\"ヌ😐🐱\"ネてけ⁵³◝ラdCg\\g]",
	"²え⁸:³\0²モこ³ハナ³◝³⁴ルナり³◝リ∧ZˇS⬆️PcO\"I2IrIQG&@6@わ@⬆️Ac@B=",
	"\0¹¹\0タ⁸:³ヒL³◝³\0ヒ²◝ラS6T8T:S<",
	"\0¹¹\0ツ⁸:³ナレ#³◝³ラb♪ネb³◝ヨ⬇️\\ルD?DOワ¹0ヲ⬆️G",
	"³ヤ⁸:ネ³ナノ³ᵉヒ\"ᶠヘ³◝ネ³ハbnヒ🐱oヒbナ³◝ルS_Soヲこg",
	"³せ⁸:▮‖\0の➡️フQヒ■ヒQヒ³ナ³◝⁘ノアqヌアヌqヌアネ➡️ヌアQアヌ■ア➡️ヌアヌ➡️ヌアヌ➡️³◝ヨdfくX➡️R➡️J",
	"³ノ⁸:ヘ▮◝▮‖きキネ➡️▮◝ラすLさJ",
	"³ノ⁸:▮‖ナ□ノ▮◝⁘ナ□ハ▮◝",
	"³ノ⁸:⁘ナ□ハ▮◝⁘ナ⁙ハ▮◝",
	"³ノ⁴:⁘ヌナ⁙ノ▮◝▮⁘ナ⁙ノ▮◝",
	"³ヒ⁸:▮ヌナハ³▶ヒb「ヘ³◝▮ヨ🐱ヌナノ³◝レ%LルTOT_ワ¹@ヲしW",
	"\0ワ⁸:ヌᵇヌMム³◝ヌᵇム🐱V🐱◝レ%lルToT○ンきz",
	
	--[[wily stage v1
	"ろ⁶:ヤナMNヒ▒MN⬅️ヌ♥IJヌ♥☉fネg)(g◝ヌナノ…ヌaヌAノgヌ!IヒgJヌ!fLネ!*⁸J(ヌ😐FH◝ヨ⧗。➡️8░@⬆️Dく▮★:ルT゜T/ヲり'",
	"ノ⁷:⁸)(ヌl⁶⁸◝ナFHヌlF*⁷◝ヨ#H★K",
	"ヒ⁷:ナ&(ヌ♥F	⁷\nJ⌂ヌナ웃I	\nJ♥ᵇ\nヌC³◝(ijH●☉FGi☉●ヌ♥☉●jGiノ▒ナ³◝レ‖lヨひJ➡️L➡️FルTOT_ワ¹`ヲるW",
	"²∧⁷:³\0³▮ナ/ナ1ノナルれヌ#ノ⬇️ナ³◝³ᶠ■ルナヌ!ヒナネ!ネナヌ¹³◝ラtjG&G'リ✽[TZsX2X■Q!Q#@3@りXの@▒Af>dGˇIfH³/%8D6e8の,へ[⁙/‖8VH",
	"⁵ク☉:ヤナ□ユれ◝のきヌのクrク□ヌクRクRヌナ□◝ヨく&▒*Q.q>q8ラu4u5さ ",
	"\0タ⁶:³ヌこヌ¹ヌナ³◝³ヌナヌ¹ヌA³◝",
	"¹\0\0¹ツ⁶:³ヌナル⬇️³◝³ル!ヌt³◝ル6?6Oワ¹0ヲさG",
	"³メ⁶:#ノaヌナ³◝³ナネ😐ヌA³◝",
	"³ヤ⁶:³ナヒCNヒ▒MフC³◝³フ¹.ヒ!-ハ¹ヌナ³◝ルS_Soヲこg",
	"³せ⁸:⁵\0マ¹ハAネ³ホAヌナ³◝⁵⁴ナ🐱ヌナ🐱ナヌ🐱ヌナヌBるヌナノ²BヌナヌBヌナBヌ🐱³◝ヨくFくL▒Y░r",
	"³ノ⁶:⁵ヒ²³◝⁵█ハA³◝ラさKさIしHしJしL",
	"³ノ⁶:⁵ナ◀ハ⁵◝⁵‖ナ「ノ⁵◝",
	"³ノ⁸:⁵‖ナ「ノ⁵◝⁵▶ナ◀ノ⁵◝",
	"³ノ⁸:⁵▶ナ◀ノ⁵◝⁵‖ナ「ノ⁵◝",
	"³ヒ⁸:⁵ヌナヌBネ³ᵉヒA\rヘ³◝⁵ラaノナa◝レ%LルTOT_ワ¹@ヲˇW",
	"\0ロ	:ネ³ノ」³◝³ナAノ」A◝",
	"¹\0\0¹ロ⁷:³ナハ⬇️³◝ヒa:a◝ルd_doンぬj",
	]]
	
	--chop man
	"⁶⁷⁷⁶る⁸*ワナ⁶◝ヌこけヌこけヌこ🐱⬇️🐱さ\"#\"さ🐱ヌ⬇️G🐱░ナ⁶◝ヨ➡️⁘a「➡️(b\"🐱▮q&➡️$",
	"⁶⁷⁷⁶キ⁷*⁶ヌるヌ✽るナ⁶◝⁶ナヌEヌ🐱E⁶◝ヨ░%く(",
	"⁶⁷⁷⁶⬆️⁸*⁶ナけヌeヌけヌeヌけヌeノけ\"'ヌeけ\0⁶◝⁶gヌこgヌこeヌナ🐱⬇️ヌG🐱░るナ🐱ナ⁸ナ🐱⁶◝ヨ▒.➡️<dHt:さ&さ,ラ7D",
	"⁶⁷⁷⁶さ☉*⁶@けヌ%ヌけ⁶◝⁶B*さ)さ@⁶◝ヨqDラuBuC",
	"⁷し웃*⁶メK\0⁶◝⁶らヌょ😐ヌょ😐ょ😐ょ😐ょ😐\r⁶◝ヨ⬇️N⬇️Z",
	"⁶⁷⁷⁶と☉*⁶ヌナ\0ネナ⁶◝⁶ヌさヌ)さ@⁶◝ヨtW",
	"⁶⁷⁷⁶と●*⁶ヌナ\0ネナ⁶◝⁶ヌナ\rネナ⁶◝ヨ★[□[R\\",
	"⁶⁷⁷⁶に☉*⁶ヌけヌ%ホけヌ⁸ᶠヒさᵉ◝⁶ヌ\nら(る✽🐱⬇️🐱✽ヌる✽🐱ネ⬇️🐱ヌ◆🐱⬇️ᵉ◝レ!mヨqX➡️\\r^ラdSeReTルToワ¹`ヲく|",
	
	--cryo man
	"⁴り⁷•れ◝ヌ█ノ`ヌ█`ノ\0⁵ナ⁶◝ヨc¥➡️▮",
	"⁶ゃ⁷•	ノ🐱⬇️ナ⁸◝⁷ナabcけa⁸◝ヨ⬆️‖",
	"⁶ょ⁸•⁷ナABCbA!#ヌBCネ🐱¹³ノb¹²⁸◝⁷けこるacナacナ*ナ*ナ¹²³ネ🐱!#ナ⁸◝ヨ░¥▒゛c:⬆️6Q,a$a(",
	"⁶タ⁷•⁵ネ🐱ACナ⁸◝⁷ナacヌdA⁸◝",
	"⁶ツ⁷•⁵ナ!#BD!¹²³BDB!\"¹³DCヌb!\"⁸◝⁷,kけkヌ,kdkdkd,dネkdヌ,mナ⁸◝ヨq<➡️FtX#:#F#R➡️R",
	"⁶メ⁷•	ノ🐱⬇️ナ⁸◝⁷ナ!#d!\"⁸◝ヨtU",
	"⁴に⁶•⁵ナacけ▒🐱ACけこネナ!\".ヒナ▮◝⁷ヌ`ネ█ネ`ハ█ABNヒ웃▮◝レ\"mヨこ^ルToワ¹`ヲる|",
	
	--fish man
	"⁸り⁸⁙れ◝フきネ`ネきヌ♥@◝ヨ▒▮く‖q゛",
	"\nゃ	⁙\0`ヌ@`ヌナ\0◝¹ナヌ\0ヌらき¹◝ヨく「A⁘",
	"\n😐	⁙\0ナ ネ¹ヘ!ヌA¹!フAネaAナW\0◝¹ヌらヌナヌらネナヌらナ@ヌナらヌ█ヌ\0@\0 \"\0ヌナ█ヌナ¹◝ヨく¥a*b゛け$▒4B@ABA7",
	"\nさ♥⁙\0007Aヌ¹ヌA\0◝¹ヌ🐱ヌ█🐱ほ¹◝",
	"	ヒ♥⁙ワナ\0◝`こヌきヌ█ヌ`ヌ@ナらd`ナ█け█け`⁴\0♥¹◝ヨくH▒Pbl➡️Zくb➡️L➡️f",
	"\nロ⁷⁙\0ネ▒A`ナ\0◝¹ナ²@B█🐱¹◝",
	"\nワ●⁙\0ナ█らヌき`@⁵ヒ▒⁶◝¹█@█ヌ`ヌ ⁵ヒ@⁶◝レ#mルSoワ¹`ヲこ|",
	
	--surge man
	"¹ら♥ᵇ\0?ハナ\0◝\0ヌAヌくヌA\0◝ヨ░³░ᵇロ★⁴★ᶜり⁸",
	"²█♥ᵇ\0かハり\0◝\0よハナ\0◝リを⁷わ	さᵇaᵇ✽\rF\r🐱⁶⬇️⁸E⁸D⁵ロ²⁸",
	"²れ♥ᵇ\0ムりヌAホりヌ⁶わヌりわり\0◝\0よヌくヌAネくノナヌ!ホナヌくしヌaヌナ\0◝ヨねᵉ░	⬆️8🐱:ラG2リtᵉS■★◀f e$3$2&a(f,⬆️'れ+り/ロり⁴➡️\n¹⁶▒¥¹⁘¹$¹&¹.Q2く8²8²2る0²(²゛B、²▮★⁸¹<",
	"\0¹¹\0タ⁷ᵇ\0ヌ✽ヌ▒ヌナ\0◝\0ヌナヌaヌし\0◝ヨひ<ロけ6!8",
	"⁵テGᵇ²◝²ヌけヌbヌけヌナるb²ヌナ🐱ナ🐱Bヌナ🐱ナ🐱ナ🐱ヌBヌ🐱ヌナ²◝ヨ🐱R★B🐱jけ^ロけ6け8り2り4り:り<くDキBrF➡️Rね\\のXの`のfのh➡️b➡️dのPねLのjのl",
	"\0¹¹\0ロ⁷ᵇ\0ヌ✽ヌ▒ヌナ\0◝\0ヌナヌaヌし\0◝ヨ➡️fロ\"hくh",
	"\0¹¹\0ほ⁸ᵇ\0ヌナヌくしヌ⁷³くしヌくしく⁴◝\0りわヌりわヌ▒⬇️りわヌりわり⁴◝レ$mルToロりb¹lりh²fRnるr²vるvる~りx¹r¹|¹pワ¹`ヲろ|",
}

--copy tileset into memory
--reduces mget() reads, less lag
function tileinit()
	tst={unpack(split("195,195,196,196,197,198,198,197,197,197,197,197,211,211,212,212,205,205,205,205,0,213,0,213,224,224,224,224,109,227,109,243,48,48,48,48,204,204,204,204,202,202,202,202,202,202,202,218,202,203,202,203,225,225,225,225,224,240,224,240,240,240,240,240,224,241,224,241,241,241,241,241"))}
	for i=0,127 do
		for j=28,29 do
			add(tst,mget(i,j))
		end
	end
end

--copy columns into work memory
function clminit()
	for i=1,#columns do
		add(eccwork,ord(columns[i]))
	end
	ectls=eccwork[ecclm*7+ectlc+1]
	fluffclm()
end

--place column
function clm(x,f,h,c,d)
	d=d or 0
	for i=0,27 do
		local lx,ly=sqdx(i,2)
		local ch=tst[1+lx*2+ly%2+2*ord(columns[c*7+1+fdiv(ly,2)])]
		ly+=f*h+max(0,f*14)-elmid
		if ch!=d and ly<14 then
			mset(lx+x,ly,ch)
		end
	end
end

function loadseg(stn)
	--clear tables
	elfwork,elcwork,elework={},{},{{},{},{},{},{},{},{},{},{}}
	--store current screen
	for i=0,13 do
		memcpy(0x2700+i*128,0x2000+i*128,16)
	end
	
	idx,elbg,elcof=0,{},0
	local function gseg() idx+=1 return ord(segments[elseg][idx]) end
	
	local ch=gseg()
	while ch<128 do
		add(elbg,ch)
		ch=gseg()
	end
	elcl,elcr,elpitr,ch=fdiv(ch%64,8),ch%8,ch&64>1,gseg()
	elpitl,elfx,elmid,ch=ch&128>1,ch&64>1,ch%64,gseg()
	elcof=ch
	
	memset(0x2000,0,1792)
	for i=0,#elbg-1 do
		clm(i*2,-1,-elmid,elbg[i%#elbg+1])
	end
	--exponential bg duplicator
	local exp=max(1,#elbg*2)
	while exp<128 do
		for j=0,13 do
			local addr=0x2000+j*128
			memcpy(addr+exp,addr,exp)
		end
		exp*=2
	end

	
	--column placer
	ch=gseg()
	exp=-1
	local xx=elcl*16
	while ch<255 do
		local cend=max(1,ch-224)
		if cend>1 then ch=gseg() end
		cnd,vsh=sqdx(ch,32)
		for i=1,cend do
			if ch!=224 then
				clm(xx,exp,vsh,cnd+elcof,0)
			end
			if exp<1 then
				add(elcwork,ch)
			else
				add(elfwork,ch)
			end
			xx+=2
		end
		ch=gseg()
		if ch>=255 and exp<1 then
			exp=1
			ch=gseg()
			xx=elcl*16
		end
	end
	
	--entity placer
	ch=gseg()
	while ch do
		if ch>=240 then
			coff=ch-240
			ch=gseg()
		end
		exp,xx=sqdx(ch,16)
		ch=gseg()
		add(elework[coff],{ch,xx,exp})
		ch=gseg()
	end
end

--[[
0..* bg columns bbbbbbbb
1..1 seg def 1plllrrr
1..1 center def pe..cccc
1..1 column idx offset ffffffff

~ rEPEAT ONCE ~
0..* column vvvccccc,
 prepend 111lllll for rle
 11100000 is always empty column
1..1 switch side/end

~ rEPEAT UNTIL END OF STRING ~
1..1 redefine type 1111tttt
1..* entity y pos/param,x pos
 yyyypppp 0xxxxxxx,32767 ttl
]]
--column offsets aren't set per
--stage, but per segment!
-->8
--level redraw
function drawseg()
	memset(0x2000,0,1792)
	for i=0,#elbg-1 do
		clm(i*2,-1,-elmid,elbg[i%#elbg+1],0)
	end
	--exponential bg duplicator
	local exp=max(1,#elbg*2)
	while exp<128 do
		for j=0,13 do
			local addr=0x2000+j*128
			memcpy(addr+exp,addr,exp)
		end
		exp*=2
	end
	
	for i=0,#elcwork-1 do
		local cd=elcwork[i+1]
		local ci,cv=sqdx(cd,32)
		if cv<7 then
			clm(16*elcl+i*2,-1,cv,ci+elcof,0)
		end
	end
	
	for i=0,#elfwork-1 do
		local cd=elfwork[i+1]
		local ci,cv=sqdx(cd,32)
		if cv<7 then
			clm(16*elcl+i*2,1,cv,ci+elcof,0)
		end
	end
end

--draw column
function drawclm(x,f,h,c)
	for i=0,27 do
		local lx,ly=sqdx(i,2)
		local ch=tst[1+lx*2+ly%2+2*eccwork[c*7+1+fdiv(ly,2)]]
		ly+=f*h+max(0,f*14)-elmid
		if ch!=0 and ly<14 then
			spr(ch,lx*8+x,ly*8)
		end
	end
end
-->8
--level editor
--[[
⬆️/⬇️: adjust column offset
⬅️/➡️: change selected column
lmb: place column
rmb: delete column
a/d: scroll
w/s: adjust vertical center
holding (,):
 🅾️/❎: change segment
 a/d: change entity type
 w/s: change entity parameter
 lmb: place entity
 rmb: delete entity
 ⬆️: select left/right edge
 ⬅️/➡️: adjust camera bounds
 ⬇️: flip pit
 (.): echo fx flip
]]

function elupdate()
	if btn(5,1) then
		--change selected edge
		if btnp(2) then
			elpsel=not elpsel
		end
		--flip pit
		if btnp(3) then
			if elpsel then
				elpitr=not elpitr
			else
				elpitl=not elpitl
			end
		end
		--adjust camera bounds
		if btnp(0) then
			if elpsel then
				elcr-=1
			else
				elcl-=1
			end
			drawseg()
		end
		if btnp(1) then
			if elpsel then
				elcr+=1
			else
				elcl+=1
			end
			drawseg()
		end
		elcl=mid(0,elcl,7)
		elcr=mid(0,elcr,7)
		
		--mouse pos
		elxp=mid(0,fdiv(mx+elx,8),127)
		elyp=mid(0,fdiv(my,8)-1,14)
		
		--change segment
		if btnp(4) and elseg>1 then
			elseg-=1
			loadseg(elseg)
		end
		if btnp(5) and elseg<#segments then
			elseg+=1
			loadseg(elseg)
		end
		elx=mid(128*elcl,elx,128*elcr)
		
		--echo fx flip
		if btnp(4,1) then
			elfx=not elfx
		end
		
		--adjust entity type/parameter
		if btnp(3,1) then
			elesel-=1
		end
		if btnp(2,1) then
			elesel+=1
		end
		if btnp(1,1) then
			elexp+=1
		end
		if btnp(0,1) then
			elexp-=1
		end
		elesel=mid(1,elesel,#elework)
		elexp=mid(elexplim[elesel][1],elexp,elexplim[elesel][2])
		
		--check pos validity
		local valid,invt,inve=true,0,0
		for lt=1,#elework do
			if valid then
				local etbl=elework[lt]
				for le=1,#etbl do
					if elxp==etbl[le][1] and elyp==etbl[le][2] then
						valid,invt,inve,mspr=false,lt,le,32
						break
					end
				end
			end
		end
		
		--place entity
		if lmb>0 and valid then
			add(elework[elesel],{elxp,elyp,elexp})
		end
		--delete entity
		if rmb>0 and not valid then
			deli(elework[invt],inve)
		end
		
	else
		--scroll
		if btn(0,1) then
			elx-=4
		end
		if btn(1,1) then
			elx+=4
		end
		elx=mid(128*elcl,elx,128*elcr)
		elxp=mid(8*elcl,fdiv(mx+elx,16),63)
		
		--change midpoint
		local omid=elmid
		if btnp(2,1) then
			elmid+=1
		end
		if btnp(3,1) then
			elmid-=1
		end
		elmid=mid(0,elmid,14)
		if omid!=elmid then drawseg() end
		
		--change column
		if btnp(0) then
			elcsel-=1
		end
		if btnp(1) then
			elcsel+=1
		end
		elcsel=mid(0,elcsel,31)
		--change column offset
		local ocof=elcof
		if btnp(2) then
			elcof+=1
		end
		if btnp(3) then
			elcof-=1
		end
		elcof=mid(0,elcof,#columns-32)
		if ocof!=elcof then
			drawseg()
		end
		
		--cursor pos
		local elflpo=elflp
		if my>=120-elmid*8 then
			elyp=fdiv(my,8)-(15-elmid)
			elflp=1
		else
			elyp=(14-elmid)-fdiv(my,8)
			elflp=-1
		end
		elyp=mid(0,elyp,7)
		
		if elxp!=elxpo or elyp!=elypo or elflp!=elflpo then
			elallow=true
		end
		elxpo=elxp
		elypo=elyp
		
		--place column
		local xpp=elxp+1-8*elcl
		local cmix=min(224,elyp*32+elcsel)
		if lmb>0 and elallow then
			if elflp>0 then
				local clmhere=elfwork[xpp]
				if clmhere!=cmix then
					while #elfwork<xpp do
						add(elfwork,224)
					end
					elfwork[xpp]=cmix
					drawseg()
					elallow=false
				end
			else
				local clmhere=elcwork[xpp]
				if clmhere!=cmix then
					while #elcwork<xpp do
						add(elcwork,224)
					end
					elcwork[xpp]=cmix
					drawseg()
					elallow=false
				end
			end
		end
		--delete column
		local xpp=elxp+1-8*elcl
		if rmb>0 then
			if elflp>0 and xpp-1<#elfwork then
				local clmhere=elfwork[xpp]
				if clmhere!=224 then
					elfwork[xpp]=224
					drawseg()
				end
			elseif xpp-1<#elcwork then
				local clmhere=elcwork[xpp]
				if clmhere!=224 then
					elcwork[xpp]=224
					drawseg()
				end
			end
		end
		while elfwork[#elfwork]==224 do deli(elfwork,#elfwork) end
		while elcwork[#elcwork]==224 do deli(elcwork,#elcwork) end
		
		--export segment string
		if btnp(5) then
			local predata={}
			for bge in all(elbg) do
				add(predata,bge)
			end
			add(predata,128+(elpitr and 1 or 0)*64+elcl*8+elcr)
			add(predata,(elpitl and 1 or 0)*128+(elfx and 1 or 0)*64+elmid)
			add(predata,elcof)
			local entdata={}
			if #elework[5]>0 then
				add(entdata,240+5)
				for j=1,#elework[5] do
					local e=elework[5][j]
					add(entdata,(e[2]<<4)+e[3])
					add(entdata,e[1])
				end
			end
			for i=1,#elework do
				if #elework[i]>0 and i!=5 then
					add(entdata,240+i)
					for j=1,#elework[i] do
						local e=elework[i][j]
						add(entdata,(e[2]<<4)+e[3])
						add(entdata,e[1])
					end
				end
			end
			lvbyt=0
			local xstr=bcount(buildstr(predata)..buildrle(elcwork).."◝"..buildrle(elfwork).."◝"..buildstr(entdata))
			printh(xstr,"@clip")
			msgtxt="copied level data ("..lvbyt.." bytes)"
			msgtime=120
		end
		
		--toggle mode
		if btnp(4) then
			tileinit()
			_upd=ecupdate
			_drw=ecdraw
		end
	end
	
end

function eldraw()
	cls()
	camera(elx,-8)
	
	map()
	
	--guidelines
	fillp(▒)
	for i=0,7 do
		line(i*128,0,i*128,112,6)
		printd(i,i*128+2,1)
	end
	line(0,112-elmid*8,1023,112-elmid*8,6)
	fillp()
	
	--entities
	for lt=1,#elework do
		local etbl=elework[lt]
		for le=1,#etbl do
			palt"2"
			eledrw[lt](etbl[le][1]*8,etbl[le][2]*8,etbl[le][3])
			pal()
		end
	end
	
	if btn(5,1) then
		--entity at cursor
		palt"2"
		eledrw[elesel](elxp*8,elyp*8,elexp)
		pal()
	else
		--column at cursor
		local by=elyp*elflp*8-56
		if elflp>0 then
			by+=112
		end
		by+=56-elmid*8
		rect(elxp*16-1,by-1,elxp*16+16,by+112,7)
		if elyp<7 and rmb<=0 then
			palt"0"
			drawclm(elxp*16,elflp,elyp,elcsel+elcof,0)
			palt()
		end
	end
	
	--hud
	camera()
	hud()
	line(0,120,1023,120,5)
	
	--column selection
	local txt="column "..elcsel+elcof.."/"..elcof+31
	print(txt,1,122,3)
	--x scroll
	txt="x:"..elx
	print(txt,128-#txt*4,122)
	--edge bounds/pits
	print(elcl.."~"..elcr,88,122,3)
	spr(elpitl and 16 or 17,84,119)
	spr(elpitr and 16 or 17,100,119)
	
	print(elfx and "e" or "",76,122,3)
	if btn(5,1) then
		print("🅾️ seg- ❎ seg+ ("..elseg..")",1,1,3)
		--edge selection
		pset(elpsel and 101 or 85,122,3)
		--entity type and parameter
		local txt=elesel..","..elexp
		print(txt,128-#txt*4,1)
	else
		print("t🅾️ggle e❎port",1,1,3)
		--column encoded value
		local cmix=min(224,elyp*32+elcsel)
		local bmix=""
		for i=0,7 do
			bmix=((1<<i)&cmix>0 and 1 or 0)..bmix
		end
		bmix=cmix..","..bmix
		print(bmix,128-#bmix*4,1,3)
	end
end
-->8
--column editor
--[[
⬅️/➡️,a/d: change column by 1
⬆️/⬇️: change column by 8
lmb: select tile
rmb: fill column down with tile
(,): add column to bg
(.): delete top column from bg
w/s: scroll tileset
]]

function ecupdate()
	--column selection
	local oclm=ecclm
	if btnp(0) or btnp(0,1) then
		ecclm-=1
	end
	if btnp(1) or btnp(1,1) then
		ecclm+=1
	end
	if btnp(2) then
		ecclm+=8
	end
	if btnp(3) then
		ecclm-=8
	end
	ecclm=mid(0,ecclm,#eccwork/7-1)
	if ecclm!=oclm then
		ectls=eccwork[ecclm*7+ectlc+1]
	end
	
	--tile scroll
	if btnp(2,1) then
		ecscr-=1
	end
	if btnp(3,1) then
		ecscr+=1
	end
	ecscr=mid(0,ecscr,14)
	
	--bg add/delete
	if btnp(4,1) and #elbg>0 then
		deli(elbg,#elbg)
	end
	if btnp(5,1) and #elbg<8 then
		add(elbg,ecclm)
	end
	
	--tile select
	if lmb>1 or rmb>1 then
		ecdragclm=(mx>=ecclmx and mx<ecclmx+16)
		ecdragtst=(mx>=ectstx and mx<ectstx+64)
	end
	local otlc=ectlc
	local otls=ectls
	if lmb>0 or rmb>0 then
		--column tile
		if ecdragclm then
			ectlc=mid(0,fdiv(my-8,16),6)
			ectls=eccwork[ecclm*7+ectlc+1]
			otls=ectls
		end
		--tileset tile
		if ecdragtst then
			local tmx=mid(0,mx-ectstx,56)
			tmx=fdiv(tmx,8)
			local tmy=mid(0,fdiv(my-8,16)+ecscr,31)
			ectls=tmx+tmy*8
		end
	end
	ectls=mid(0,ectls,254)
	if otls!=ectls or rmb>1 then
		local tloop=rmb>0 and 6 or ectlc
		for i=ectlc,tloop do
			eccwork[ecclm*7+i+1]=ectls
		end
	end
	
	--export columns string
	if btnp(5) then
		pruneclm()
		columns=""
		for i=1,#eccwork do
			columns..=chr(eccwork[i])
		end
		printh(buildstr(eccwork),"@clip")
		msgtxt="copied column data"
		msgtime=120
		fluffclm()
	end
	
	--toggle mode
	if btnp(4) then
		columns=""
		for i=1,#eccwork do
			columns..=chr(eccwork[i])
		end
		_upd=elupdate
		_drw=eldraw
		drawseg()
	end
end

function ecdraw()
	cls()
	camera(0,-8)
	
	--draw column
	if ecclm<#eccwork/7 then
		drawclm(ecclmx,-1,-elmid,ecclm)
	end
	
	--draw tileset
	for i=0,27 do
		local tx,ty=sqdx(i,4)
		for j=0,3 do
			local px,py=sqdx(j,2)
			spr(tst[1+ecscr*16+px*2+py%2+tx*4+ty*16],ectstx+px*8+tx*16,py*8+ty*16)
		end
	end
	
	--draw column selection box
	rect(ecclmx-1,ectlc*16-1,ecclmx+16,ectlc*16+16,7)
	rect(ecclmx-2,ectlc*16-2,ecclmx+17,ectlc*16+17,0)
	
	--draw tile selection box
	local tsx,tsy=sqdx(ectls,8)
	tsx*=8
	tsy*=16
	tsx+=ectstx
	tsy-=ecscr*16
	rect(tsx-1,tsy-1,tsx+16,tsy+16,7)
	rect(tsx-2,tsy-2,tsx+17,tsy+17,0)
	if (ectls+1)%8==0 then
		rect(tsx-65,tsy+15,tsx-48,tsy+32,7)
		rect(tsx-66,tsy+14,tsx-47,tsy+33,0)
	end
	
	--draw gray bg
	for i=0,1 do
		rectfill(0,0,ecclmx-2,111,i*5)
		rectfill(ecclmx+17,0,ectstx-2,112-i,i*5)
		rectfill(ectstx+65,0,127,112-i,i*5)
	end
	
	for i=1,7 do
		rectfill(26,-11+i*16,38,-5+i*16,6)
		local txt=tostr(eccwork[ecclm*7+i])
		while #txt<3 do txt="0"..txt end
		print(txt,27,-10+i*16,13)
	end
	
	camera()
	hud()
	line(ectstx+65,120,127,120,0)
	
	print("column "..ecclm.."/"..#eccwork/7-1,1,122,3)
	
	--[[local xp=#elbg>0 and 124 or 123
	for i=0,#elbg-1 do
		print(elbg[#elbg-i],xp,122,3)
		if i>0 then
			print(",",xp+3,123,3)
		end
		xp-=6
	end
	print("bg:",xp-6,122,3)]]
	
	local bgtxt="bg:"
	for i=1,#elbg do
		bgtxt..=elbg[i]..(i==#elbg and "" or ",")
	end
	print(bgtxt,128-#bgtxt*4,122)
	
	print("t🅾️ggle e❎port",1,1,3)
end
__gfx__
000000000800000000000000e0000eeee000000ee0000eeeee0000ee0000000eeeeeee7777eeeeee01300310eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000087800000000000000dddd0ee0d0cc0d00f77f0eee0ffff0e0d000d0eeeee77eeee77eeee03011030eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
000000008778000000000000d0cc0deed0cccc0d077770ee0ff77ff00d0ccd0eeee7eee77eee7eee03051030eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
000000008777800000000000d0cc0deed0cccc0d077770ee0f7777f00d000d0eee7eeee71eeee7ee01888810eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000087777800eeeeeeee0dddd0ee0d0cc0d00f77f0ee0f7777f00d0ccd0eee7eee7317eee7eee018810eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000087788000eeeeeeeee0000eeee000000ee0000eee0ff77ff00d000d0ee7eeee3771eeee7ee081080eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000008878000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ffff0e0dcccd0ee7eeee7717eeee7eee0510eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000ee0000000ee7eee733717eee7eee0650eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000000000000777777c0777777c0ee7e7eeeeeeeeeeeeeeeeeeeeeeeeeeee76ee133111ee67eee0510eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000000000000700000d07fffffd0e6e7e6eeeeeeeeeeeeeeeeeeeeeeeeeeee767774477767eeee0650eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
000000000000000070dd00d07f77ffd07e676e7eeeeeeeeeeeeeeeeeeeeeeeeeee766777777667eeee0510eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
000000000000000070d000d07f7fffd0e77677eeeee88eeeeee00e0000e00eeeee000000000000eeee0650eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000000000000700000d07fffffd07e676e7ee8870eeeeee0709999070eeee02477077077420eee0000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0000000030300000700000d07fffffd0e6e7e6ee87770eeeeee0000000000eeee02447744774420ee065510eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
3330000003000000cdddddd0cdddddd0ee7e7eeee8870eeeee09970bb07990eee00000000000000e05551110eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
03000000303000000000000000000000eeeeeeeeeee88eeeee000000000000eeeeeee013310eeeee00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0888880022ee2eeeee0000ee11111111eeeeeef7feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
8877788022eee2eee0ccdd0e11111111eeeeef7eeeeeeeeeeeeeffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
878777802e2eee2e0ccd99d011111111eeeef7ef77feeeeeeeef7efeeeeeeeeeeef7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
87787780eee2eee20dd9979011111111eeee77f7777feeeeeee7eeeeffeeeeeeef7efeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
877787802eee2eee0dd9999011111111eef77f777777feeeeef7eee777feeeeee7feeeeeccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
88777880e2eee2ee0ccd99d011111111eeef777777777eeeee77ee77777feeeef7eeeccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
08888800ee2eee2ee0ccdd0e11111111ef77777777777eeeee77eef77777eeeef7eeeeeccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000eee2eee2ee0000ee11111111eeef777777777eeeee77ef77777feeeef7eeeecccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
2eee2eee2eee2eee2eee2eee2eee2eeeeef77f777777feeeeef7eee777feeeeee7feeeeeccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e2eee2eee2eee2eee2eee222e2eee2eeeeee77f7777feeeeeee7eeeeffeeeeeeef7efeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ee2eee2eee2eee2eee2e2222222eee2eeeeef7ef77feeeeeeeef7efeeeeeeeeeeef7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eee2eee2eee2eee2eee22eee2e22eee2eeeeef7eeeeeeeeeeeeeffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
2eee2eee2eee2eee2eee2e2e222e2eeeeeeeeef7feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e2eee2eee2eee2eee2ee222222eee2eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ee2eee2eee2eee2eee2ee222ee2eee2eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eee2eee2eee2eee2eee2eee2eee2eee2eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeeeeeeeeeeeeeeeeee00eeeeeeeeeeeeeeeeeeee0dcd0eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ccc0eeeeeeeeeeeeeeeee0dd0eeeeeeeeeeeeeeeeeee0dd00eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0dcc0d0eeeeeeeeeeeeeee0dd0eeeeeeeeeeeeeeeeeee0dcd0eeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeee00eeeeeeeee0eeeeeeeeeeeeeeeeeeeee0ddccddd0eeeeeeeeeeeeee0d0eeeeeeeeeeeeeeeeeeee0dccdeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee0dd0eeeeeee0d0eeeeeeeeeeeeeeeeeeee00dddd0000eeeee000eeeee0d0eeeeeeeee0000eeeeeeee0dcd0eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee0dd0eeeeeee0d0eeeeeeeeeeeeeeeeeee0dcc00cccdd0eee0ddd0eeee0d0eeeeeeee0cccc0eeeeeee0dd00eeeeeeeeeeeeeeeee
ee0eeeeeeeeee00eeeeeeeeee0ddd0eeeeee0d0eeee00eeeeeee00eee0dddcccc000dd0eee0dd0eeeee00eeee0000dddddd0000ee0dcd0eeeeeeeeeeeeeeeeee
e0d0eeeeeeee0dd0eeee00eeee0dc0eeeee0d0eeee0cc0eeeee0cd0ee0dd0ddddccc0d0eee0d0eeeeee0c0ee0ddddcccddcdddd0e0dccdeeeeeeeeeeeeee0eee
0ddd0eeeeee0ddd0eee0dd0eeee0cc0000c00eeee0dccc0000ccddd0ee000dddcc0cc0eeee00000eeeee0cc0e0dccdddddcccd0eee0dcd0eeee0cc00eee0dc00
0dddcc00000cddd0000ddd0eeeee0ccccc00eeee0ddd0cccccc0ddd0eeee0cddc0ccd0eeee0cd0d0eeeee0ccee0cccdccdccc0eeee0dd00eee0d0cccee0dd0cc
0d0000ccc0cccd0eccdddd0eeeeee0cccc00eeee0ddd00cccc000dd0eeee0cc000dddd0ee0ccddd0eeeee0cceee0dddccdcd0eeee0dcd0eee0d0d0ccee0dd0dd
00dd0cdddc0000ee000000eeeeeee0ddddcc0eee0dd0e0ddddcc000eeeee0cd0ee00000ecdc0dd0eeeeee0ddee0ddcddcdddd0eee0dccdeee0dd00ddeee000cd
0dddcccd0cc0eeee0cc0eeeeeeeee0cddccdd0eee000e0cddccdd0eeeeee0ddd0eeeeeeedd00000eeeee0cddeee0000000000eeeee0dcd0ee0dd0ccdeeeee0cc
0d0ddc00ccd0eeeeccd0eeeeeeeee0cc00dddd0eeeeee0cc00dddd0eeeeee0dd0eeeeeeedccdddd0eeee0cc0eeeeeeeeeeeeeeeeee0dd00eee00ddc0eeeee0cc
000000e0dddd0eeedddd0eeeeeeee0cd0e00000eeeeee0cd0e00000eeeeee0dd0eeeeeee0cddddd0eeee0cd0eeeeeeeeeeeeeeeee0dcd0eee0dddd0eeeeee0cd
eeeeeee000000eee00000eeeeeeee0ddd0eeeeeeeeeee0ddd0eeeeeeeeeeee00eeeeeeeee0000000eeee0dd0eeeeeeeeeeeeeeeee0dccd0ee000000eeeeee0dd
eeeeeee000eeeeeeeeeeee000eeeeeeeeeeeeee0000eeeeeeeeeee0dd0eeeeeeeeee00dd0e000eeeeeeeeeeeeeeeeeeeee0000eeddddddddeeeeee000eeeeeee
eeeee00ccc0eeeeeeeeee0ccc00eeeeeeeeeee0cccc0eeeeeeeeee0dd0eeeeeeeeee0dd0eeeeeeeee000eeeeeeeeeeeee0f77f0eddddddddeeee00ccc00eeeee
eeee0dddd000eeeeeeee0cc0ddd0eeeeeeeee0c0dddc0eeeeeeeeee00eeeeeeeeeee000eeeeeeeee0ddd00eefffeffeee0ffff0eddddddddeee0dd000dd0eeee
eeee0ddddccd0eeeeee00ccdddd0eeeeeeee0cdddddc0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedcccdc0e111e11eeee0000eeddddddddeee0ddcccdd0eeee
eee0cd770d070eeeeee0ddddd0cc0eeeeeee0dccd771d0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedf0f0d0eeeeeeeeeeeeeeeeeddddddddee0d771d177d0eee
eee0cd770f070eeeeee0ddddd0cc0eeeeeee0dccd771f0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ddd00eeee11eeeeeeeeeeeeddddddddee0c771f177c0eee
eee0cdffffff0eeeeee0ddddd0cc0eeeeeee0dccdffff0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeeeeeeeeeeeeeeeeeeeddddddddee0dfffffffd0eee
eeee0ddffff0eeeeeeee0dddddd00eeeeeeee0ddddff0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddeee0dfffffd0eeee
eee0cc0000c0eeee00c0eeeeeee0cc000000eeeeeee00cc0000ccdeeeee0deee00ccdeeeeeeeeeee00ccdeeeeee0cc0000c000eeeeeeeeee0000dd0e00ccdeee
ee0dcccccc0c0eeecc0c0eeeee0dccccccc0eeeee00dcccccccccdee000cdeeeccccdeeeeeee0c00ccccdeeeee0dcccccc0d0d0eeeeeeeeeccc0dd0eccccdeee
e0ddd0cccc0dd0eecc0dd0eeee0dd0cccc00eeee0ddddc0cccc000eec0000eeecc000eeeee0000cccc000eeee0ddd0cccc00dd0eeeeeeeeec0ccdd0ec0000eee
e0ddd0dddd0dd0eedd0dd0eeee0ddd0dd0d0eeee0dddd0dddd00eeeedc0eeeeed00eeeeee0dd0cd0ddcc0eeee0ddd0ddddc0dd0ee0cc0000dd0dd0eedd00eeee
e0dd0ccddcc0d0eedc0dd0eeee00dd0c0c0eeeeee00d0ccddcc0eeee0cc0eeee0c0eeeee0dddcccddccdd0eee0dd0ccddcc000eee0ddccccd0c00eeed0cc0eee
ee00ddc00ccd0eeeccc00eeeeee000dd000eeeeeee00ddc00ccd0eeeccd0eeee000eeeee0d0ddc0000dddd0eee00ddc00cdd0eeee0ddd0cd0ddc0eee0ddc0eee
ee0dddd00dddd0eedddd0eeeeeee0dddd0eeeeeeee0dddd00dddd0eedddd0eeed0eeeeee000000e00e00000ee0dddd0e0dddd0ee0ddd00000dd00eee0dd00eee
ee000000000000ee00000eeeeeeee00000eeeeeeee000000000000ee00000eee00eeeeeeeeeeeee0d0eeeeeee000000e000000ee0000eeeee0dd0eeee0dd0eee
e000000000000000eeeee000000eeeeeeeeeeee0000eeeeeeeeeeee00000eeee00000dc77cd00000eeeeee0000eeeeeeee000000000eeeeeee0000000000eeee
e066660666667760eeee07776670eeeeeeeee00aaa0eeeeeeeeee0099990eeee000ddd0cc0dd1000eeee00999700eeeeee0788007870eeeeee0222227880eeee
e00000066667760eeee0777775570eeeeeee03333300eeeeeeee0dd999d0eeee00dccdd00dddd100eee0999999790eeeee0078800870eeeeee00888027880eee
eeee0406677600eeee006666666600eeeee0333333330eeeee000dd999dd0eee0dccdddccdddd110eee0999999990eeeee70078888870eeeeee8778802780eee
ee00447000000eeee07776007070070e0e03a37003070eeeee09dd7799970eee0dcddd7cccddd110eee0000909000eeeee00880000000eeeee87777702800eee
ee0664770f070eeeee077600707000ee3033a37003070eeeee099d7709070eee1dddddc77cdd1110ee099999999990eeee708077777780eeeee87788020870ee
eee0644fffff0eeeeee0765555550eee0330a3333f330eeeeee09dff9fff0eeec1dddd0cc0d1110cee000000000000eeee080780000000eeeeee8880080700ee
eeee044f77f0eeeeeeee06655550eeee0000033ff0f0eeeeeeee0ddffff0eeee71de76d00d67e107eeeeeeeeeeeeeeeeee07870707070eeeeeee020007870eee
eee06600006000eeeee077000070eeeeeee0aa0000a0eeeeeee09900009000ee71d7700dd0077107eeee00777770eeeeee07870770770eeeeeee020007870eee
ee0466666604040eee06777777070eeeee03aaaaaa0a0eeeee000999990d0d0ec1d7700ee007710ceee0907070700eeeee080780000000eeeeee8880080700ee
e04440666600440ee0666077770660eee03330aaaa0330eee0d0d0999900dd0ed1d7700ff007710deeee00770770eeeeee708077777780eeeee87788020870ee
e04440444460440ee0666066660660eee0333033330330eee0dd00dddd90dd0ed1de77f0ff77e10deee0990090090eeeee00880000000eeeee87777702800eee
e0440664466000eee0660776677060eee0330aa33aa030eee0dd099dd99000ee00dffffeffeee100ee099990009990eeee70078888870eeeeee8778802780eee
ee00446006440eeeee00667007760eeeee0033a00aa30eeeee00dd9009dd0eee000dffff00fe1000ee000000000000eeee0078807870eeeeee00888027880eee
e044440e044440eeee066660066660eeee033330033330eee0dddd0e0dddd0eecd10dff0ffe101dceeeeeeeeeeeeeeeeee0788000870eeeeee0222227880eeee
e000000e000000eeee000000000000eeee000000000000eee000000e000000eecccd005fe500dccceeeeeeeeeeeeeeeeee000000000eeeeeee0000000000eeee
066770667776500000005776665f500000002eee444000000000149ffff990000001ddddddcd1000ddddddddddddddddee000eeeeeeeeeeeeee777fffff077ee
0006506666677765000f77666577ff000004eeee44400000001dd4999999000001cccddddddcc100dcdd7cdddddc77cde0fff0ee000eeeeee777777ffffff77e
02400666666666777577766657777ff0002ee4113311000001dcd999999410001cc7ccdddddccc10ddddc7c77dd77711ee0600e0fff0eeeeee7700700fff07ee
04440666666666667f77f66657777ff500e41333333110000dcdd99999901100dc7cccddddddccd0dddd77c711c77c1dee060f09ffff0eee7770f07000f00777
24406666666666666777666577777fff0241333333331100dddd499999411100ccccccddddddccc1777711dddd7771ddee060f99ffff0eeee770fffffffff07e
44405556666666667775556577777fff04133333333316104ddd999999011110ccccccddddddccc1c7771c771c77c1ddee060f99ffff90ee777700fff0f00077
4440675555566666667555507777ffff42333367633305619ddd999999ff9914ccccccddddddccc1d7771777777711ddee060f99ffff90eee77770ff0777077e
2544000677555555666655507777ff55133336500633007194dd999999999414ccccccd111151cc1dc7777777771d11dee060f99f00f90eeee77000f070007ee
775427700077777560666666666555553e4337000733006199dd444999999114ccccc519999111c1dd7777c777c1d11dee060f990ee090eeeee07770f0ff0eee
6764277076000566600766666665577f72e43600563f3611994d770449994114dcccd19779995111ddc77717771dd11dee060090eeee00eeee07777700000eee
66642e77775070006007007000657777e844336763ffe111494d770049906112dddd197779994111dd1d11177c1dd11dee06000eeeeeeeeeee07700770070eee
565442e77ee77220060000700065f777e84433333ff00e10091de707090771401ddd197799944111ddd1ddd771dd11ddee060eeeeeeeeeeeee077700770770ee
054442eeff4fe200065500000065fff71442331eff000e1001ddde779f77e1001111149999424110ddd11dd711d111dde00000eeeeeeeeeeeee00077770770ee
504442e00ffff2005065555550655fff4001131fff00e104441ddeeff4fe10000111154442245100dddd11dd11111ddde8c8f8eeeeeeeeeeeee07777700770ee
650442e770ff20056506555550655005ee400131ffee104e9940dde0fff10000001dd15444451000dcdddd11111dddcde09990eeeeeeeeeeeeee000000000eee
6665420effe200566650055506550677eeee400000004eee999401de0e1000000001111111110000ddddddddddddddddee000eeeeeeeeeeeeee0fff0e0fff0ee
777777777777777a00000000000000002000000000020200000202007c7777c7000000000000000000000001011111101110111144440000000000007777777a
7aaaaaaaaaaaaaa900aaa00000000000200000000222220000020200cdccccdc666666666666666111111111001111000000000044400004555555557aaaaaa9
7a99999a99999aa90a09090020000000200000002200000222220222000dd00065555555555555510001000001111110111111104400004466666666799999a9
7aa999aa901107a90a90a90920022222200222220200020000020000000cc0006567777777777651000100000111101011111110400004447777777779011079
7aaa9aaa900007a90a0a0900200000002000000022000202222222227c7777c76566666666666651000100000111101011111110000044446666666679000079
7aaaaaaa90dd07a90099900000000000200000000202220000000000cdccccdc65555555555555511111111100110100000000000004444055555555790dd079
7a999999900007a90000000000000000200000000000000000020200000dd0006570000000000651000000011111111111101111004444001111111179000079
7a90000000cc07a9009a900000000000200000000002020000020200000cc00065750565500506510000000111111111111011110444400000000000790cc079
7a900000c00007a9009a900000000000d000000000000000aaaaaaaa7d7777d765700000000006510001000109994094000000005ffff5510677765079000079
7a90c0c0c0cc07a9009a900000000000d0000000cdccddcd99999999d1dddd1d6570000000000651110101110444404406006006f555555105676510790cc079
7a900c0c000007a9009a9000d0000000d0000000d0dd00d000000000000110006575056550050651000500000000000000756570555555500567651079000079
7a90000c00cc07a9909a9000d00dddddd00ddddd00000000d0d0d0d0000dd00065700000000006510024200050555505005776500000000001151100790cc079
7a900000000007a9009a9000d0000000d000000000000000d0d0d0d07d7777d7657000000000065100f940000000000006677666f5515fff0567651079000079
7aa77777777777a9009a900000000000d00000000000000000000000d1dddd1d65555555555555511249421194090499005661505551f555056765107a777779
7aaaaaaaaaaaaaa9009a900000000000d000000000000000aaaaaaaa00011000655555555555555100242001440404440075657055505555056765107aaaaaa9
a999999999999999009a900000000000d00000000000000099999999000dd00000000000000000000000000100000000060060060000000005676510a9999999
dddddddd000001d100011110dddddddd99999999999999983111333333333333001ddddddd111000677777770000000077777776767777670567651005676550
dddddddd1000001001566551eedddddd980000000000008211611111113333336777777777776650d66777760076776776601665656666560567651005676655
dddddddd1000100115665515eeeddddd9800000000000082161733333113333356767777667655107dd6666d0777777765555555000550000567651005677666
dd1ddddd0011d10001555151eeeddddd98e0000000000e8211711611131133335676777766765510777dddd7077777c751111111000660000567651005667777
ddd1111d01dd110000115110eeeeddee980000000000008231116173113133331151555511511000677777760d777c6677777776767777670567651005566666
11dd111101d1100055101105eeeeeeee980000000000008233311711313133335676777766765510d677776d05c7665576601665656666560567651000555555
111111110110001065510056eeeeeeee8222222222222222333311113131333356767777667655107d6666d70567655165555555000550000567651000011111
d111111d0011011151510056eeeeeeee2111111111111111333333313131333356c677776676551077dddd770567651051111111000660000567651000000000
dcdddddddccccccd51100565dddddddd882888281110111033333311717113335dcd777766765510000000000000000099999990656666560000000055676510
dcddddddddccdcdd10550155ddddddde822288283b313b3111111110000011111dcdc7ccd6cd1510776777677767700090000020515555150e00e00e56676510
dcddddddcddddddc05565011ddddddee22828822bbb1bbb1333333700000633356767777667655107777777777777700900000900001100000e0e0e066776510
dcddddddccddcdcc01551500eeeddeee82228888bbb1bbb1111111100000111156767777667655107777c777777777d0900222900005500000000e0077766510
dddddcdddccccccd00115510eeeedeee88288888bbb1bbb133333370000063331151555511511000c77c67cc7c777d1090022290656666560ee00eee66665510
dddddcddddcdccdd55101105eeeeeeee88222228bbb1bbb1111111100000111156767777667655105d755d555c67c5109002229051555515000eee0055555110
dddddcddcddddddc65510056eeeeeeee888888283b313b3133333311616113335676777766765510111111115567c510929999900001100000e0e0e011111100
dddddcddccdcddcc51510056eeeeeeee888888281110111033333331111133331151555511511000000000000567651000000000000550000e00e00e00000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000424242000000002a4242000000000042424242010101422242420042c2424242000142024242424242424252002a42420004420242424242424252524222c242
__map__
f4f4e6e7e6e7f4f4f4f4e6e7e6e7f4f4e4e5e4e5f5f5e4e5e4e5f5f5e4e5e4e5c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1eee0e0e0e0e0e0e0e0e0e0e0e0e0e0eeddcacccccccccacacacacccccccccadde2e2f2f2e2e2f2f2e2e2f2f2e2e2f2f20000000000000000000000000000000000000000000000000000000000000000
f4f4f6f7f6f7f4f4f4f4f6f7f6f7f4f4f4f4c6c5c3c4c3c4c3c4c3c4c6c5f4f4d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1eee0e0e0e0e0e0e0e0e0e0e0e0e0e0eedddacccccccccadacadacccccccccaddf2f2e2e2f2f2e2e2f2f2e2e2f2f2e2e20000000000000000000000000000000000000000000000000000000000000000
f4f4f5f5f5f5f4f4f4f4f5f5f5f5f4f4f4c6c5c6c3c4c3c4c3c4c3c4c5c6c5f4c1dcdcdcdcdcdcdcdcdcdcdcdcdcdcc0ee6d6d6d6d6d6d6d6d6d6d6d6d6d6deeddcbcccccccccbcbcbcbcccccccccbddcedcdcdcdcdcdcdcdcdcdcdcdcdcdcce0000000000000000000000000000000000000000000000000000000000000000
f4f4e6e7e6e7f4f4f4f4e6e7e6e7f4f4f4c5c6c5c3c4c3c4c3c4c3c4c6c5c6f4d1c4c6c5c6c5c3c4c3c4c6c5c6c5c3d0eef3e3f3e3f3e3f3e3f3e3f3e3f3e3eeddcacccccccccacacacacccccccccaddf2e1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
f4f4f6f7f6f7f4f4f4f4f6f7f6f7f4f4f4c6c5c6c3c4c3c4c3c4c3c4c5c6c5f4c1c4c5c6c5c6c3c4c3c4c5c6c5c6c3c0ee4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeddcbcccccccccbcbcbcbcccccccccbddf2e1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
e4e5f5f5f5f5e4e5e4e5f5f5f5f5e4e5f4c5c6c5c3c4c3c4c3c4c3c4c6c5c6f4d1c4c6c5c6c5c3c4c3c4c6c5c6c5c3d0ee4e4e4e4e4e4e4e4e4e4e4e4e4e4eeedbcacccccccccacacacacccccccccadbf2e1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
ecc6c5c6c3c4c3c4c3c4c3c4c5c6c5ececc6c5c6c3c4c3c4c3c4c3c4c5c6c5f4ecc4c5c6c5c6c3c4c3c4c5c6c5c6c3ecee4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeeccacccccccccacacacacccccccccaddece1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
ecc5c6c5c3c4c3c4c3c4c3c4c6c5c6ececc5c6c5c3c4c3c4c3c4c3c4c6c5c6f4ecc4c6c5c6c5c3c4c3c4c6c5c6c5c3ecff4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeeccacccccccccacacacacccccccccaddece1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
ecc6c5c6c3c4c3c4c3c4c3c4c5c6c5ececc6c5c6c3c4c3c4c3c4c3c4c5c6c5f4ecc4c5c6c5c6c3c4c3c4c5c6c5c6c3ecec4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeeccacccccccccacacacacccccccccaddece1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
ecc5c6c5c3c4c3c4c3c4c3c4c6c5c6ececc5c6c5c3c4c3c4c3c4c3c4c6c5c6f4ecc4c6c5c6c5c3c4c3c4c6c5c6c5c3ecec4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeeccacccccccccacacacacccccccccadde2e1e1e1e1e1e1e1e1e1e1e1e1e1e1f20000000000000000000000000000000000000000000000000000000000000000
e4e5f5f5f5f5e4e5e4e5f5f5f5f5e4e5f4c6c5c6c3c4c3c4c3c4c3c4c5c6c5f4d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6ec4e4e4e4e4e4e4e4e4e4e4e4e4e4eeedbdbdbdbdbdbc8c9c8c9dbdbdbdbdbdbcececececececececececececececece0000000000000000000000000000000000000000000000000000000000000000
f4f4e6e7e6e7f4f4f4f4e6e7e6e7f4f4f4c5c6c5c3c4c3c4c3c4c3c4c6c5c6f4c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1ec4e4e4e4e4e4e4e4e4e4e4e4e4e4eeeddddddddddddd8d9d8d9ddddddddddddf2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f20000000000000000000000000000000000000000000000000000000000000000
f4f4f6f7f6f7f4f4f4f4f6f7f6f7f4f4e4e5e4e5f5f5e4e5e4e5f5f5e4e5e4e5d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1eaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaddddcdcdcdcdcdcdcdcdcdcdcdcddddde2e2f2f2e2e2f2f2e2e2f2f2e2e2f2f20000000000000000000000000000000000000000000000000000000000000000
f4f4f5f5f5f5f4f4f4f4f5f5f5f5f4f4f4f4f4f4e6e7f4f4f4f4e6e7f4f4f4f4c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1eaeaeaeaeaeaeaeaeaeaeaeaeaeaeaeaddddcdcdcdcdcdcdcdcdcdcdcdcdddddf2f2e2e2f2f2e2e2f2f2e2e2f2f2e2e20000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013000013
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013000013
c2d20000eeeecfdcdccf00c0c100c700d700ed00fd00f4f400e4e5f4f4f5f5f6f7e6e7868600f2f2dcdcf200e2e2000000d5edf1ed0000eeeaeaee00deeadede00ebfafafbeffafaffe8e900dddd00c8c9dbdbddddeaebfb00ff00ef0000fafad6d600000000dcdcd6d6d0d1d0d100dcd2c2dc00d600d600cf00cece0000aaab
d2c2d6d6eeeedf0000df00d0d100d700d700fd00fd00f4f400f4f4e4e5e6e7f5f5f6f7868600f2f20000f200f2f200dcdce1fdf1fde200eeeaeaee00eeeaeeee00eeeaeaee00000000f8f900dddd00d8d9dddddbdbeaeeee00000000dbdbdddd0000ebfafafbd6d6c0c1c0c1dcdc00dcc2d2dc00d6d6d600df0000000000babb
0000000000000000030303050505040600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
