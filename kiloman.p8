pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--kiloman
--by trianull
--base megaman spriteset
--by flowme

function _init()
	_g=_ENV
	--disable btnp repeat
	?"⁶!5f5c◝"
	--custom font widths
	?"⁶!5600⁴⁸⁸"
	--custom font
	?"⁶!5a00\0lモモ★🐱D\0\0ららck>6▮\0\0<N^<\0\0\0\0ョョ|、\0\0\0⁘⁸I6I⁸⁘\0⁸9○◝y、\0\0>゛~>「⁸\0"
	
	--head,hofs,bodyl,bodyr,feet,face,dofs,buster
	--hofsx=n%5-2,hofsy=n/5
	--dofsx=n%5,dofsy=n/5
	kspr=split("96,2,96,97;96,7,64,65;96,2,99,100;96,7,78,66;96,2,67,68,102,2;98,3,74,110,104;-777,2,71,72;96,2,96,98;96,3,101,102,-1,0,0,●;96,7,64,103,-1,0,0,●;96,2,99,104,-1,0,0,●;96,7,105,66,-1,0,0,●;96,2,67,106,102,2,0,●;100,2,74,111,104,0,0,●;100,2,74,111,104,0,0,●;96,3,101,102,-1,0,0,●;96,2,96,97,-1,4;96,2,69,70,102,6;-777,2,77,-1,-1,0,-1;75,-23,75,76,-1,0,15;-777,2,75,76,-1,0,15;96,15,109,73,-1,2,5;-777,0,0,0;96,2,107,108;96,2,93,108;100,2,79,104,102,0,0,●;100,1,107,108;96,2,107,108;110,3,107,108;100,2,101,104,-1,0,0,●",";")
	kwpn=split"0;15;7;▥,0;15;7;█,0;8;15;▒,0;13;12;🐱,16;4;6;⬇️,16;6;7;░,16;3;14;✽,16;13;9;●,16;0;5;♥"
	for i=1,9 do
		kwpn[i]=split(kwpn[i],";")
	end
	
	--[[
	save data layout:
	 0 : stages beaten
	 1 : e-tanks
	 2-4:intentionally empty
	 5-8:weapons acquired
	 10-14:which e-tanks grabbed
	]]
	svchk(not cartdata"trianull_kiloman")
	
	fblnk,_upd,_drw,tanm,stg,ttmr,
	fd,gt=function()end,fade,cls,
	split"9bfff7,02dddd,28ccddbdccdfddcc2cddc,0a2222233334eeeee0000,88cd1dbd101e0000,5c888888202b2000",
	usp"5,0,2,128"
	--tanm:1/spd,[col,swap*4]
end

function svchk(d)
	for i=1,8 do
		if d then
			dset(i,0-fdiv(i,5))
		end
		kwpn[i][1]=dget(i)
	end
	etnk=dget"1"
end

function fade(fn,arg)
	fn,cntdwn=fn or tologo,0
	for i=1,4 do
		fd+=1
		wait"2"
	end
	wait"10"
	fn(arg)
	wait"10"
	for i=1,4 do
		fd-=1
		wait"2"
	end
end

function tointro()
	_drw,_upd,cntdwn,gt,boss,
	plr=drw_intro,upd_intro,380,128,
	new_boss(60,58,stg),nil
	music"61"
end

function togame()
	boss,wpn,seg,_drw,_upd,
	plr,kwpn[3][1]=nil,0,
	cps,drw_game,upd_game,
	new_plr(),0
	loadseg()
	cl,cx,bars=cpl,cpl,true
	--run once to update hud
	plr:update()
	loadmus(stg)
	menuitem(2,"exit stage",function() cntdwn,pause=90,false end)
end

function toselect()
	svchk()
	_drw,_upd,cx,mstg,bars,pause,plr=drw_select,
	upd_select,0,1,false,false,nil
	loadmus(6)
	?"⁶!42fc\0"
	menuitem(2)
end

function tologo()
	reload()
	_drw,_upd,bars,cntdwn,cx,cy=drw_logo,
	upd_logo,false,usp"182,0,-8"
	music"59"
end

function totitle()
	_drw,_upd,gt,stg,cntdwn=drw_title,upd_title,128,0,2300
	music"50"
end

function _update60()
	gt+=1
	bpx,bpo=btnp"5",btnp"4"
	_upd()
end

function _draw()
	cls()
	--need this fade check because
	--of weird map flickers
	if fd<6 then
		pal()
		palt"0"
		drawcomets()
		camera(cx,cy)
		
		_drw()
		
		camera()
		--letterboxing
		memset(usp"0x6000,0,512")
		memset(usp"0x7e00,0,512")
		
		if bars then
			for dx=1,3 do
				dbar(dx,0x7e40+dx*22-18)
			end
			print("ᵉ"..gkwpn(1,4).."         █         ▒",usp"0,120,6")
		end
		
		--fade palettes
		pal(split(split"1;2;131;4;5;6;7;136;9;10;139;12;140;143;15;7,1;2;131;4;5;6;7;136;9;10;139;12;140;143,0;0;0;2;0;5;6;2;2;9;131;140;1;4;143,0;0;0;0;0;0;5;0;0;2;0;1;0;2;4,0;0;0;0;0;0;0;0;0;0;0;0;0;0;2"[fd],";"),1)
		if stg>=6 and fd==2 then pal(usp"8,8,1") end
		
		--persistent palette changes
		?"⁶!5f2e\0"
		if fd==2 then
			?"⁶!5f2e¹"
		end
	end
end

function docnt(t,a)
	cntdwn-=1
	if cntdwn<=0 or a then
		music"-1"
		fade(t)
	end
end
-->8
--draw

--assemble man in spritesheet,
--way easier to flip this way.
--function credit: donbattery
function cspr(nh,img)
	h,o,bl,br,ft,fc,dro,b=usp(kspr[img])
	--remap draw state to the sprite-sheet (so spr() writes into gfx)
	?"⁶!5f55\0"
	--draw sprites from the sheet to the new spot
	camera()
	rectfill(usp"0,0,15,23,14")
	rectfill(usp"0,24,31,31,14")
	if dro then
		camera(sqdx(dro,-5))
	end
	palt"2"
	local hx,hy=sqdx(o,5)
	if nh and h>=96 then fc=nil h+=nh end
	spr(h,hx-2,hy,2,1)
	local blj,brj=fdiv(bl,80),fdiv(br,80)
	spr(bl+blj*16,0,blj*8,1,2-blj)
	spr(br+brj*16,8,brj*8,1,2-brj)
	if ft then
		spr(ft,usp"0,16,2,1")
	end
	if fc then
		local hf=fdiv(fc,4)*4
		sspr(88,53-hf,6,fc,hx+4,7-hf+hy)
	end
	if b then
		spr(106,hx+18,24)
	end
	--restore draw state back to the screen
	?"⁶!5f55<"
	camera(cx,cy)
end

function dbar(n,hx)
	for i=0,5 do
		for j=9,n,n-9 do
			memset(hx+i*64,gkwpn(j,fdiv(i,2)%2+2)<<4,ceil(gkwpn(j)))
		end
	end
end

function printd(t,x,y)
	for p=3,0,-1 do
		print(t,x+p%2,y+p/2,7<<p*4)
	end
end

function drawtitle(xx,yy,tcode)
	spal"13,8,12,7"
	for i=1,#tcode do
		local tidx=ord(tcode[i])
		if tidx==255 then
			xx=16
			yy+=1
		else
			local ox=xx
			xx+=tidx>>>3&-1
			line(ox,yy,xx-1,yy,tidx%8)
		end
	end
end

function drw_title()
	spal"1,0,3,4,5,6,7,8,9,10,11,12,13,13,15,0"
	map(0,16)
	drawtitle(16,20,"P1「9⁸)▮)8!8!▮)()(」▮!◝P1⁸A▮)▮)(A(!⁸1 1(」▮!◝H1⁸9「)▮)(Q「a 1 )⁸」◝Ha()▮) Y「Y 9 I◝Ba▮¥)▮)▮¥)⁸1\na⁸¥」⁸」⁸¥I⁸\"◝⁸:S「\"+⁸\n+⁸¥+▮3⁸c⁸□•▮#□K◝▮*I「*)▮)▮¥)⁸\n)⁸!⁸」⁸!⁸\nQ⁸\nI◝「\"C▮:+⁸\n+⁸¥3⁸\n+⁸#⁸\nᵇ▮#⁸\nT▮、⁸,◝ ¥C⁸:+▮+▮¥3⁸+⁸$▮□⁸$▮[⁸#▮•◝(\nS:+⁸\n,⁸*\\⁸#⁸\"#⁸\n$「$⁸$▮、◝0\\*,▮は⁸$▮\"$⁸$◝(3⁸3\"+⁸\nd⁸D▮$◝(4⁸\n4□,▮d▮\n⁸$「□◝ 4▮□4\n,⁸□`\"◝ 4⁸\"0\n(🐱◝Xソ◝`ち◝hz◝pJ◝x¥◝")
	printd(" ロックマンヒ\+de゜\|iコ!!\n\|かtrianull 2026",38,34)
	print("\f8🅾️ \f7continue\n\|i\f8❎ \f7new game",20,72)
	palrst()
	pal(1,0)
	cspr(nil,1+16*fdiv(gt%98,89))
	spr(usp"0,96,49,2,2,true")
end

function drw_select()
	cls"13"
	map(usp"16,16,0,0")
	printd("\+☉fstage select\n\|😐chop man\-❎cryo man\n\|➡️fish man\-⧗surge man",8,6)
	
	if fdiv(gt,8)%2==0 then
		local msx,msy=sqdx(mstg,3)
		if msx==1 then msy=.5 end
		map(124,24,8+msx*40,16+msy*48,4,4)
	end
	
	
	pal(14,0)
	local rm=4
	for j=24,72,48 do
		for i=16,96,80 do
			rm+=1
			if dget(rm)>0 then
				spr(32,i,j,2,2)
			end
		end
	end
	
	if dget"0">=4 then
		spr(usp"170,56,48,2,2")
	end
end

function drw_game()
	--palette cycling
	tm=tanm[stg]
	ttmr+=1/tm[1]
	ttmr%=4
	
	for i=2,#tm,5 do
		pal(tonum(tm[i],1),tonum(tm[i+ttmr+1],1))
	end
	
	map(0,16,cx,str*112,16,14)
	map(usp"0,0,0,0,128,14")
	
	palrst()
	
	--tile shadows
	for i=0,509 do
		local shx,shy=sqdx(i,17)
		if shy!=14 then
			shx+=shy>15 and 0 or fdiv(cx,8)
			if fget(mget(shx,shy-1))>=42 and fget(mget(shx,shy))<=1 then
				if shy>15 then shy-=16-14*str shx+=fdiv(cx,8) end
				spr(2,shx*8,shy*8)
			end
		end
	end
	
	kcol=kwpn[wpn+4]
	if pause then
		drw_menu()
	else
		for e in all(nmes) do
			local ipal=split"1,13,12,12"
			if e.ice>0 then
				pal(0,ipal[fdiv(e.ice,60)+1])
			end
			if e.hit<=0 then
				e:draw()
			else
				e.hit-=1
			end
			pal(0,0)
		end
		for r in all(xtrs) do
			r:draw()
			palrst()
		end
		if boss then boss:draw() end
		if plr then plr:draw() end
		for b in all(blts) do
			b:draw()
		end
	end
end

function drawcomets()
	sd=rnd()
	srand"8"
	for i=0,20 do
		local sp=rnd()+.33
		local sx=flr(-gt*sp)
		for j=1,8 do
			pset(sx%136+j-8,(128*(i/25)-sx)%128-j,split"7,7,12,12,13,13,1,1"[j])
		end
	end
	srand(sd)
end

function drw_intro()
	map(32,18+fdiv(gt,8)%2*6,usp"0,32,16,6")
	boss:draw()
end

function drw_menu()
	local mx=cx+72
	for shy=1,10 do
		for shx=0,6 do
			shx+=8+cx/8
			spr(150,shx*8,shy*8)
		end
	end
	rectfill(mx,16,cx+111,79,0)
	color"6"
	for i=2,6 do
		j=i
		if i>2 then i+=2 end
		if gkwpn(i)>-1 then
			dbar(i,0x6328+j*0x200)
			if not (wpn==j-2 and fdiv(gt,8)%2==0) then
				print("ᵉ"..chr(j+128),mx,3+j*8)
			end
		end
	end
	print("🅾️",mx,67)
	for i=1,etnk do
		spr(7,mx+i*8,65)
	end
	printd("hold for pause",mx-8,88)
end

function drw_logo()
	local white=split(split"1;0,1;0,1;3,1;3,1;6,1;9,1;15,10;15,13;15"[mid(1,fdiv(gt,2)-18,9)],";")
	local function wht()
		for i=white[1],white[2] do
			pal(i,7)
		end
	end
	cls()
	pal()
	if stg>=6 then
		pal(0,1)
		printd("thanks for playing!\n\+uypresented by\n\+k░special thanks to:\n\+ymdonbattery\n\-▒merwok\n\-yjadelombax\n\-mthisismypassport",26,15)
	end
	--blue
	spal"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
	wht()
	for i=-1,1 do
		for j=-1,1 do
			spr(11,44+i,52+j,5,1)
		end
	end
	--gold
	for i=1,15 do
		pal(i,split"9,15,4"[i%3+1])
	end
	wht()
	if gt>54 or cntdwn<60 then gt=0 end
	spr(usp"11,44,52,5,1")
end
-->8
--update
function upd_game()
	if pause then
		local wc=bnp"3"-bnp"2"
		repeat
			wpn+=wc
			wpn%=5
		until gkwpn(wpn+4)>=0
		if wc!=0 then sfx"45" end
		if bpo and gkwpn"2"<16 and etnk>0 then
			etnk-=1
			dset(1,etnk)
			fillbar(2,16)
			plr.hp=gkwpn"2"
		end
		if btnp"6" or bpx then
			?"⁶!5f30\1"
			pause,plr.warpdir,plr.warp,plr.yv=false,usp"-1,8,0"
		end
	else
		if bpo then pflp=not pflp end
		lr,ud=bn"1"-bn"0",bn"3"-bn"2"
		
		if plr then plr:update() end
		if boss then
			boss:update()
			if plr and overlap(boss,plr) and plr.invul<=0 then
				plr.hp-=3
				if plr.hp>0 then
					plr:hurt()
				end
			end
		end
		
		for e in all(nmes) do
			if e.ice>0 then
				e.ice=min(e.ice-1,240)
			else
				e:update()
			end
			e:check()
			if e.hp<=0 then e.sp.can=true del(nmes,e) end
		end
		
		for b in all(blts) do
			b:update()
			b:motion()
			if b.ttl<=0 then del(blts,b) end
		end
		
		--set yoku blocks solid
		fset(252,0x42)
		
		for r in all(xtrs) do
			r:update()
			if r.ttl<=0 then del(xtrs,r) end
		end
		
		if cntdwn>0 then
			docnt(stg>=6 and tologo or plr and toselect or togame)
		end
	end
end

function upd_select()
	lr,ud=bnp"1"-bnp"0",bnp"3"-bnp"2"
	
	local ostg=mstg
	mstg+=lr+ud*3
	mstg%=6
	if ostg!=mstg then sfx"45" gt=0 end
	
	if bpo and (dget"0">=4 or mstg%3!=1) then
		music"-1"
		sfx"63"
		stg=split"1,5,2,3,5,4"[mstg+1]
		cps,cpl,gt=split"1,9,16,23,30"[stg],0,120
		for i=1,9 do
			fd=i%2+1
			wait"6"
			gt-=.5
		end
		fade(dget(stg+4)<0 and tointro or togame)
	end
end

function upd_intro()
	boss:update()
	docnt(togame,bpo)
end

function upd_logo()
	if stg<6 or bpo then
		docnt(totitle,bpo)
	else
		cntdwn-=1
	end
end

function upd_title()
	docnt(tologo)
	if btnp()>=16 then
		if bpx then
			memset(usp"0x5e00,0,255")
			svchk"true"
		end
		sfxa"63,3"
		fade(toselect)
	end
end
-->8
--helpers
function fdiv(a,b)
	return flr(a/b)
end

--only useful in some situations
--adds 1 token on most loops
function sqdx(v,p)
	return v%p*sgn(p),fdiv(v,p)
end

function spal(s)
	pal(split(s))
end

function wait(n,p)
	if plr and not p then plr.anim=plr.anim&-1 end
	_draw()
	for i=0,n do
		flip()
	end
end

function bnp(n)
	return tonum(btnp(n))
end

function bn(n)
	return tonum(btn(n))
end

function tfget(xx,yy)
	return fget(mget(xx/8,yy/8))
end

--made inline in loadseg
--[[
function sfxfx(n)
	for i=0x3f44,0x42fc,68 do
		poke(i,n)
	end
end
]]

function overlap(a,b)
	return a.x < b.x+b.w and
		a.x+a.w > b.x and
		a.y > b.y-b.h and
		a.y-a.h < b.y
end

function gkwpn(a,b)
	return kwpn[tonum(a)][b or 1]
end

function fillbar(b,a)
	a=gkwpn(b)+a
	while gkwpn(b)<min(16,a) do
		kwpn[b][1]+=1
		sfxa"35,3"
		wait"1"
	end
end

function atbl(tbl,x)
	local obj=add(tbl,x)
	obj:init()
	return obj
end

function offscreen(o)
	return o.x<cx-o.w or o.x>=cx+128 or o.y<cy or o.y>cy+120+o.h
end

function palrst()
	pal()
	palt"2"
end

--token saving mvp
function usp(v)
	return unpack(split(v))
end

function sfxa(a)
	sfx(usp(a))
end
-->8
--level

--goes by 2 to index metatiles
--use rle if low on space
--max(1,248-n)
columns="\0\0\0\0\0\0\0²²²²²²²⁴⁴⁴⁴⁴⁴⁴⁶⁶⁶⁶⁶⁶⁶ᶜᵉ▮▮▮▮▮▮▮▮▮▮▮▮□□□□□□□◀「「⁘⁘⁘⁘、゛゛゛゛゛゛ \"\"\"\"\"\"¥¥¥¥¥¥¥:::::::=:::::?GGGGGGG;=::=;;999==99ACEEEAC:::?⁴⁴=::::=:?PJJJJJJJJJJJJLSPJJJJJU777777W\"\"LLLLYJJJKN¥IJJJMII\n¥¥¥¥¥¥\\\\\\\\\\\\\\e[[[[[if\\\\\\\\\\jg]]]]]kSf\\\\\\□ja]]]]]]`[[[[[[]]]]]]][[[[[[[\\\\\\\\y]]z((((((mf\\\\\\\\\\mmf\\\\\\\\Sg]]]]]{[^^^^}5777777ZZ]ZZZZupppppwu⁸⁸⁸⁸⁸uSupppppsupppwLpppppppsu⁸⁸w⁘██□█pupw█□Suppp█⁘Suppp🐱pppppjm🐱ppppj777🐱pppoou⁸poos⁸⁸⁸pqq2444444░²²²²²²😐🅾️🅾️🅾️🅾️🅾️…///////444⁴⁴⁴⁴&²²²²²²●^^^^^i♥さささささj☉ZZZZZk{iさささ{idkさささdk🅾️🅾️🅾️🅾️🅾️🅾️🅾️Sjさ/さj♥\n⁶⁶⁶⁶⁶お▤/////*▥/////,$$$$$$$&$$$$$+★★★★★★★⧗⧗⧗⧗⧗⧗⧗ˇˇˇˇˇˇˇ∧∧∧∧∧∧∧s😐🅾️🅾️🅾️🅾️🅾️/////*う/////,い"

segments="⁶⁷⁷⁶る⁸*ワナ⁶◝ヌこけヌこけヌこ🐱⬇️🐱さ\"#\"さ🐱ヌ⬇️G🐱░ナ⁶◝ヨ➡️⁘a「➡️(b\"🐱▮q&➡️$ュ"
--copy in remaining level data
for i=0x2000,0x2700 do
	segments..=chr(peek(i))
end
--"," couldn't be avoided :(
segments=split(segments,"ュ")


--copy tileset into memory
--reduces mget() reads, less lag
tst={usp"195,195,196,196,197,198,198,197,197,197,197,197,211,211,212,212,205,205,205,205,0,213,0,213,224,224,224,224,135,227,135,243,48,48,48,48,204,204,204,204,202,202,202,202,202,202,202,218,202,203,202,203,225,225,225,225,224,240,224,240,240,240,240,240"}
for i=0,127 do
	for j=30,31 do
		add(tst,mget(i,j))
	end
end

--place column
function clm(x,f,h,c)
	for lx=0,1 do
		for ly=0,13 do
			local ch=tst[1+lx*2+ly%2+2*ord(columns[c*7+1+fdiv(ly,2)])]
			ly+=f*h+max(0,f*14)-vmid
			if ch!=0 and ly<14 then
				mset(lx+x,ly,ch)
			end
		end
	end
end

function loadseg(stn)
	--clear tables
	blts,nmes,xtrs={},{},{}
	--store current screen
	for i=0,13 do
		memcpy(0x2800+i*128,0x2000+fdiv(cx,128)*16+i*128,16)
	end
	
	local idx,loop,coff=0,{},0
	local function gseg() idx+=1 ch=ord(segments[seg][idx]) end
	
	gseg()
	while ch<128 do
		add(loop,ch)
		gseg()
	end
	cl,cr,pitr=fdiv(ch%64,8)*128,ch%8*128,ch&64>1
	gseg()
	
	--echo fx
	for i=0x3f44,0x42fc,68 do
		poke(i,min(ch&64,0x30))
	end
	
	pitl,vmid=ch&128>1,ch%16
	gseg()
	coff,crr=ch,cr
	
	memset(usp"0x2000,0,1792")
	for i=0,#loop-1 do
		clm(i*2,-1,-vmid,loop[i%#loop+1])
	end
	--exponential bg duplicator
	local exp=max(1,#loop*2)
	while exp<128 do
		for j=0,13 do
			local addr=0x2000+j*128
			memcpy(addr+exp,addr,exp)
		end
		exp*=2
	end
	
	--column placer
	gseg()
	exp=-1
	local xx=cl/8
	while ch<255 do
		local cend=max(1,ch-224)
		if cend>1 then gseg() end
		cnd,vsh=sqdx(ch,32)
		for i=1,cend do
			if ch!=224 then
				clm(xx,exp,vsh,cnd+coff)
			end
			xx+=2
		end
		gseg()
		if ch>=255 and exp<1 then
			exp,xx=1,cl/8
			gseg()
		end
	end
	
	--entity placer
	local function entp()
		if ch>=240 then
			coff=ch-240
			gseg()
		end
		exp,xx=sqdx(ch,16)
		gseg()
		atbl(xtrs,new_xtr(ch*8,xx*8,coff,exp,32767))
		gseg()
	end
	
	--if w-plate,plot before scroll
	gseg()
	--[[if ch==245 then
		repeat
			entp()
		until ch>=240
	end]]
	
	--scroll if applicable
	str=stn or 0
	if str!=0 then
		cy=str*112-8
		plr.y+=str*112
		for i=0,55 do
			cy-=str*2
			plr.y-=str*.2
			wait(0,true)
			gt+=1
		end
		cy=-8
	end
	str=-1
	
	--place the rest after scroll
	while ch do
		entp()
	end
end

mus=split("²¹⁷²¹⁷⁶ᵇ⁸⁶ᵇ⁸ᶜ⁴⁸ᶜ⁴⁸\r⁵	🅾️³\n「¹⁷³⁵³もれ⁶ョ²⁷EMUx|◜CKS◜hlx|ョ\0W¹⁴⁸ᶜᵉ◜¹⁴⁸ᶜᵉ◜■⁘、゛ョ²U¹⁴ᶜ◜¹■、゛◜¹⁴■⁘◜¹⁴⁸ᶜᵉ■⁘「、゛ョ²'▮2◜&.6ョ●W²⁶\nᵉ◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛ョゅ&dt◜&.6>◜l|ョゅ²ᶜ¥、゜◜¥◜²$□4◜!⁴)ᶜ■⁘◝⌂nt}…☉✽}░◜~bhm░|uqt◜⌂mc…☉✽n⌂mk…☉✽}░◜⌂}○…☉|○⌂ik…☉✽}░◜⌂nt|oo⌂nt|cc◜⌂nt}…☉✽}░⌂nt}…☉✽}░◜aて`0`て`0`てl<hてX◜aて`0`てbて`0`て`YてX(XてZてX(LてX◜aて`0`て`YてX(XてXUてT$TてTMてD⁘LてT◜aて`0`てbて`0`てXaて`0`て0`Lてl<hてX◜⬅️⬅️…☉░}mt○○tmib◜`hl☉⬅️…☉|☉⬅️░|ltwlilo◜hmbhl○○t}vlhoo◜hknju~⌂mv|█☉…▤うさて◜◝+¹²`³⬅️■³ᶜ■³ᵇ	³ᶜ\n⁴ᵉ□⁴ᶠ□³ᵉ⁶³▮⁷⁴⁵⁙⁴⁵⁙³\r⁸⬇️\r⁸「█³²😐\0⁷⁴⁵⁵⁷るVョ█‖²ョ█▶³ョ¹う³ョ¹\0 ◜⁸「◜¹⁵	\r■‖」。ョ²も¹ᵇᶠ■•◜⁴⁸ᶜ⁘「、ョ🐱W²⁶\nᵉ□◀¥>◜²⁶\nᵉ□◀¥゛ョ⁴‖\"2◜ᶠ◜ᶠョ⁵³³⁶¥◜³⁶◜\n▶¥◜²□◜²□゜◜²□◜²□゜◜\n▶¥ョわVカ◜ねョ⁷W¹■ョ⁷%⁴⁷⁘、◜☉ス◜☉▤ョ\r%▶ョ⁸#\r゜◜\r。◜\r゜◜\r。ョ\n'☉ス◜☉▤◜⁴⁷⁘、◜★ョᶜY¹■ョ\r⁵³⁶¥◜³⁶、◜³⁶ョ\r▶ᶠ◜ᶠ◜ᶠョオT²⁴⁶\nᶜᵉ□⁘◀¥、◜²⁴⁶\nᶜᵉ□⁘◀¥、゛◝ツき`◜¹\\、◜IもHxHもJもHxHも8Aも@p@もBも@p@や◜IもxIもJもxIもHAもpAもBもpAも@◜たt@き▥ˇ▥⬆️😐░♪たt@⬆️▥く▥ˇ▤⬆️😐◜{py🐱ypy✽x░x😐░😐⬆️█yqhdp◜{py🐱ypy●😐░⬆️😐⬆️♪░█✽█░😐◜█y▒x✽😐✽▒x🐱y▒x●♪●█x◜▤ˇ😐✽♥♥█░😐✽psss◜▤ˇ😐✽♥♥x░😐✽x{{{◜そく▤ˇ❎❎😐⬆️き▥░♥♥♥◜そく▤ˇ❎❎░⬆️▤ˇ🅾️◆◆✽◜😐✽♪░ˇ▤ˇ♪░🅾️✽♪░∧▥∧😐░◜♥█✽🅾️✽█✽⬆️❎❎😐✽▒xp😐◜♥█✽🅾️✽█✽❎❎く▤⬆️あ⬆️😐◜♥█✽🅾️✽█✽❎❎く▤⬆️▥⬆️▤き◜dqyqh\\eqid\\eqidT]jd\\◜dqyqhdqyqh\\eqid\\eqi\\◜き⬆️▤⬆️😐░█░█░😐⬆️▤⬆️😐░き▤⬆️▤きそき▤⬆️▤き▤⬆️😐░😐◜◝+ᶜ\n\rᵇ	ᵉ⁵¹ᶠ⁶²▮⁷³■☉⁴■「³⁷¹W¹⁵り⁶り²⁴😐ョ\0#²⁶□◀◜²⁶□◀。◜i{◜i{ョ¹³゜ョ⁵³]◜ᶜ゜◜ᶜョ¹w▶◜ᶠ◜ᶠョ⁸w゜ョ²⁵EU◜EU◜|◜;゛ョ²%⁸X◜⁸X◜◜◜¥◜¥。゜ョっV\0▮◜\0▮ョっ²\nᶜ、◜\nᶜ¥、◜ョっvᶠョゅr▮ョ\nWセョゅR ᵇ\r■◜¹ᵇ\r■•。◜ョ♥[゜◜◜◜\nᵉ◜\nᵉ¥゛◜²⁶□◀◜²⁶□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛ョᶜも¹	■◜¹	■ョ²\0-◜-ョ⁸\0-=◜M◜ᶠ◜\0/◜⁴ᵇ\rᶠ⁘¥、◜⁴ᵇ\rᶠ⁘•。◜⁷▶◜⁷▶。゜◜⁷ᶜ▶、ョ²S゜◜゜◝●s`h`hp|xph●こ…▤…▤きてそき▤◜●s`h`hp|░|x●い😐▤😐░🅾️✽◜|○○○y|{{{{◜|○○○y|{{◆◆◜`\\L`\\@8@LT\\T`\\TL`\\Lh`\\T\\TLT\\😐░|x◜`\\L`\\@8@LT\\T`\\TL`\\Lh`\\T\\h\\Tzq◜i\\L@h\\La\\U]TI@HLTLH^TW◜i\\L@h\\La\\U]TI@HLTLH^fi◜q\\px|xqiq]hq\\px|xqsip◜q\\px|xqiq²q\\px|xq♪✽|y◜xq\\px|xqiqh\\hq\\px|xp,@T\\p\\T◜\0q\\px|xqiqh¹q\\px|xqh😐✽hx◜Ah@\0@hB8\0@\0▮\0Ah@\0@hA\\8T@LI◜Ah@\0@hB8\0@\0▮\0Ah@\0@hATh\0H\0h@◜qhVh8AhM@hLqhVh8qh}xi◜qhVh8AhM@hLqhVh8jA\0h\0◜MhNh8MhNhLIhJh8Ih\\@ThL◜◝+¹³■²⁶▶	⁴□\n⁵⁙	⁴□\n⁵⁙▮\r⁘ᶠᵉ⁘ᵇ⁸‖😐⁷◀◀A⁴⁵⁷A⁶りVり⁶り$⁶もョ@²⁸\n◜⁸\nョ¹:9|ョ²³⁸\nᶠ゜◜⁴⁶\r⁘◀゜◜⁴⁶\r⁘◀◜⁸\nᶠ◜ᶜ¥ョ³'ᶜ゛◜ᶜ◜<◜゛◜゛ョ⁴⁙゜ョ⁶W\"2◜\"2ョ⁶#゜◜゜ョI□゜ョゅ⁶y。◜」[ョょ²¥◜²□◜²□ョょ&゛◜\\ョょ\"゜◜゜ョアV5◜5ョイ◀ᶠョ\r⁷|ョウ\"\0³⁙◜³⁙ョウT6◜6ョウ⁘▮ョ…[²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥゛◜²⁶\nᵉ□◀¥>◜²⁶\nᵉ□◀9|ョᶠ\0\0◝T\\dle\\SUPH@T\\dlePqldmd\\d◜T\\dle\\SUPH@T\\dld\\PU▥T▥…☉◜dlpxql_eglpxq\\✽█x█⬇️◜くうˇ♪∧❎😐⬆️くうˇ♪ふぬそぬは◜くうˇ♪∧❎😐⬆️くうˇ♪え⬆️😐❎x◜dlpxql_eglpxpl\\fg😐⬆️◜ˇ😐⬆️たうくう⬆️え🅾️ˇ😐⬆️たきえ♪⬆️❎◜ˇ😐⬆️たうくう⬆️え🅾️ˇ😐⬆️たひねそきそつ◜5d4HPH6d4HPH6d4HPH<Ap@PTP@◜5d4HPH6d4HPH6d4HPH🐱x⬇️h◜e⬆️f😐f⬆️dp█xf⬆️f😐e⬆️😐∧P\\◜e⬆️f😐f⬆️dp█xf⬆️f😐ey█⬇️◜⬆️❎えけえ⬆️🅾️うか⬆️😐⬆️❎❎◜⬆️❎えけえ⬆️♪えか⬆️😐⬆️❎x█░😐◜ˇ❎えけえ⬆️♪えか⬆️😐❎❎◜\0⬆️❎えけえ⬆️🅾️うか⬆️😐❎❎◜e😐f😐⬆️]😐^♪U😐V😐░Q😐R♪◜e😐d😐d😐⬆️e😐d😐d😐⬆️e😐d😐d😐⬆️q😐pうp♪◜e😐d😐d😐⬆️e😐d😐d😐⬆️e😐d😐d😐⬆️Q😐P😐\\♪◜⬆️d😐⬆️e😐lきp😐きq😐⬆️😐\\♪]😐\\⬆️d😐⬆️e😐d◜e😐dy😐xq😐pm😐le😐dy😐x▒😐░🅾️⬆️◜e😐dy😐xq😐pm😐le😐dy😐xm😐le♪◜e😐f😐⬆️]😐^♪U😐V😐░P♪P◆◜◝+「¹ 」²!「¹⁙」²◀¥	⁘•\n‖¥	⁘•ᵇ□、³ᶜ。⁴\r、³ᶜ。⁵▮゛⁶ᵉ゜⁷ᶠ゛⁶ᵉ❎⁸■ᶜ⁷⁷る⁶⁵⁵D⁴⁸😐ATョ\0³*2◜*2◜\"&04◜\"&04◜\"&04◜\"&04◜\"&04◜\"&04ョ²g\0◜\0⁸◜\0⁸◜\0◜\0⁸◜\0⁸ョ²Y,:◜,y◜,:◜,:◜,y◜,むョっ²$◜$◜$ョっf\0◜\0◜\0ョᵇ%すの◜すキ◜すの◜すキ◜すr◜すrョエXへ◜ロ>◜へョ‖>8◜V;ョˇ[•◜⁴ᶜ□¥]◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥◜⁴ᶜ□¥ョ◀\0ᵇ\r◜³⁵(\r■⁙6•◜³⁵(\r■⁙6•◜³ᵇ■」◜³ᵇ■」◜ᵇ\r」•◜ᵇ\r「◜ᵇ\r」•◜ᵇ\r「ョ`V•ョ」も²▮◜²▮◝}웃➡️▥⧗▥え▥い➡️웃✽◜u✽웃➡️⬅️➡️▥⧗웃✽}u◜t~⧗い|て♥⬅️⧗さ…◜t~⧗きな|てにせおさう▤◜t~⧗きな|てにせに…☉◜x🐱❎か█ぬ⬅️◆❎そ⬆️◜x🐱❎きの█ぬはつけそきう◜x🐱❎きの█ぬはめよ⬆️😐☉░|t◜t|○▥い…☉⧗✽웃✽}u◜t|○▥いさうせとしえ▥➡️◜t|○▥いさうしえしにに◜OOOUY[[UE◜OOOYjkk`XT◜SSSY]__YI◜SSS]nood\\X◜OOOYkkてさう▤…☉◜SSS]ooぬそきう⬆️😐☉░|t◜웃u}웃✽웃}✽mu}らまてさう…◜mu}웃}m웃➡️웃}웃✽}u◜}웃➡️▥え▥웃u✽웃➡️▥➡️✽◜웃u}웃✽웃}✽mu}✽}u◜imu✽}m✽웃✽u}ueh▤◜S▤QS\0▤\0o▤nqe▤XTあ◜N\0▤\0M¹E▤\0N\0▤\0M¹E▤◜F\0▤\0E¹1▤\0F\0▤\0E¹1▤◜N\0▤L1EL\0▤XF\0▤D)=D\0▤X◜>\0▤<。=D\0▤L:\0▤LE=8\0▤0◜O▤MO\0▤\0[▤X[T\0▤◜O▤MO\0▤\0k▤hk\0`▤T◜S▤QS\0▤\0_▤\\_X\0▤◜S▤QS\0▤\0o▤lo\0d▤X◜▤☉|▤☉|▤☉|▤☉|▤☉|▤☉|▤☉|▤☉|▤☉|▤◜…░t…░t…░t…░t…░t…░t…░t…░t…░u◜◝+⁶¹⁸⁷²	⁴¹⁸✽³\nᶜ²⁷りVAV²ᵉョ\0³¹³⁶	ᵇ\rᶠ□◜¹³⁶	ᵇ\r□‖◜¹³⁶	ᵇ\r□‖ョ\0W‖◜ᶠ◜ᶠョ\0▶◀◜▮◜▮ョ\0'X◜X◜Xョ\0#•◜•◜•ョれ⁴03v◜03v:ョれ²□‖◜□‖ョDV|ョE⁴03v◜03v:ョE²□‖◜□‖ョ⁷^A	□‖8◜A	□‖「◜A	□‖「ョ	>•゛ョ⁷\0⁵\r◜⁵\r◜⁵\rョ♥[⁴ᶜ◀、゛◜⁴ᶜ◀、>◜⁴ᶜ9<゜ョ웃;◀ョ♥]▮⁙◜▮⁙◜▮⁙ョ♥S⁷ᵇᶠ◜⁷ᵇᶠ◜⁷ᵇᶠ◝y]dqzqy✽∧🅾️ˇ❎😐░█p◜y]dqzqy▒●🐱qsxpdp◜y]dqz▒♪ˇあ∧♪◆░█xp◜dpx░⬆️░xpdpx░⬆️░😐⬆️●🐱{hpx█░😐◜⬆️😐░█░█xpdpx█░█px🅾️●🐱rxphd◜xdpxdpxdpxdpxpx█z🐱♥⬆️▤⬆️😐░█◜xdpxdpxdpxdpxpx█∧🅾️●🐱hdTd◜KきpHぬJぬき\0@ぬpIpAきJ@HきPきp◜;きp8ぬ:ぬき\0@ぬpUpQきA4@HきPく◜;き█8ぬ:ぬき @ぬp9p9きAく|くhき◜◝+¹⁷ᶠ⁶²■¹⁷ᶠ⁶²■³⁸▮³⁸▮³	▮³\n▮³ᵇ▮³ᶜ▮⁵\r▮░ᵉ▮ᶜ\0%³W⁸⁷²●ョ\0S¹⁶	ᵇ\r■◀」•。ョ\0U\"⁷2▶ョ█[⁴ᶜ⁘、◜ ³⁵(ᵇ0⁙‖8•]◜⁴ᶜ⁘、>◜⁴ᶜ⁘、>◜⁴ᶜ⁘、>ョ⁴\0\0◜0ョ⁵³¹³⁵⁷	ᵇ\rᶠ⁙‖▶」•。゜◜¹⁶	ᵇ\r■◀」•。ョ⁶WB⁷R▶ョᵉ🐱¹⁶	ᵇ\r■◀」•。◜¹⁶	ᵇ\r■◀」•。◜¹³⁵⁷	ᵇ\rᶠ■⁙‖▶」•。゜ョᵉサB⁷R▶◜B⁷R▶◝/p,/9p@H$/p,/9p@H$◜qhpdpTHqhpdHTHqhpdpTHqhpdr◜HT\\Hp\\HT\\HT\\pT\\xHT\\Hp\\HT\\HT\\pTq◜スもそもp😐そ😐x😐x\\p\\H,「もそもp😐そ😐x😐x\\p\\q◜\0▮「▮p4「4@4@HpHdpdpxq⬆️x⬆️き⬆️きそpそq◜-95%-95%-9AKU]i◜-//9AH$-//9AH$◜x\\Tx\\Tx\\Tx\\TH\\Ty\\Tx\\Tx\\Tx\\TH\\pT◜😐░x😐░x😐░x😐░x😐░x✽x\\░x\\░x\\░x\\THT\\◜も░xっ░xろ░xひ░xそ░x😐そ░xひ░xそ░x▤░x😐░そ😐◜😐░x░xhpx░😐░xpx░😐▤⬆️░xpx░😐░▤きそひそ▤き◜▤きそひそひそきもひた▤きそひそき▥⬆️░x░xhpxphdT◜「$,$,H,HTHT\\T\\x░x░😐░😐そ😐そひそひもひもスノ◜もたもたもそもたもたもそもたもたもそもたもたもそ◜-//9AH$-//9AH$◜-//9AH$-//9AHT◜-95%-95%-95'-;◜◝","+")

function loadmus(m)
	--sprite flags->sfx instrument
	memcpy(0x3200,m>6 and 0x3044 or 0x3000,68)
	local idx,addr=0,0x3244
	local function gseg()
		idx+=1
		ch=ord(mus[m][idx])
		return ch
	end
	
	--music table
	for i=0x3100,0x31ff,4 do
		pmb=gseg()
		poke(i,gseg(),pmb,gseg())
		if pmb>=128 then break end
	end
	
	--speed
	gseg()
	for i=0x3285,0x3b08,68 do
		poke(i,ch)
	end
	
	--base fx
	while gseg()<224 do
		pma=ch
		gseg()
		for i=0,pma%64 do
			for j=0,63,2 do
				poke(addr+j,pma&192,ch)
			end
			addr+=68
		end
	end
	
	--specific fx
	while ch<255 do
		if ch==253 then
			pma,addr=gseg(),0x3244+(ch&63)*68
			pmb=gseg()
		elseif ch==254 then
			addr+=68
		else
			for i=0,(ch&224)>>>4,2 do
				poke(addr+(ch&31)*2+i,pma&192,pmb)
			end
		end
		gseg()
	end
	
	--notes
	addr=0x3244
	while gseg()<255 do
		local npos=0
		while ch<254 do
			--print(((addr-0x3200)/68)..":"..(npos/2).."+"..(ch%4)+1)
			for i=0,ch%4 do
				poke(addr+npos,peek(addr+npos)+(ch>>>2))
				npos+=2
			end
			gseg()
		end
		poke(addr+0x42,npos/2,0)
		addr+=68
	end
	music"0"
end
-->8
--classes

function env(obj,par)
	return setmetatable(obj,{__index=par or _ENV})
end

function wpncost(n,r,t)
	if r==t then
		kwpn[1][1]=max(0,gkwpn"1"-n)
	end
end

function explode(o)
	for i=0,15 do
		atbl(blts,new_blt(o.x+5.5,o.y-o.h/2,i>7 and -.8 or -1.6,7,i/8))
	end
end

--bullet class
function new_blt(nx,ny,nkblt,t,dir,nxv,nyv)
	bspw={
		fblnk, --p
		function(_ENV) --k
			ttl,xv=16,nxv/100
		end,
		function(_ENV) --c
			xv=0
		end,
		function(_ENV) --f
			ttl,xv=32,nxv/100
		end,
		function(_ENV) --s
			xv*=1.5
			y+=2
		end,
		fblnk, --globe flake
		function(_ENV) --pop particle
			xv,yv,ttl=sin(dir)*kblt,cos(dir)*kblt,nkblt<0 and 300 or 15
		end,
		fblnk, --pellet
		fblnk, --bubble
	}
	bupd={
		fblnk, --p
		function(_ENV) --k
			x,y=man.x-4+sin(ttl/(xv*-1600))*8*abs(dir)+xv*400,man.y-3
		end,
		function(_ENV) --c
			if kblt>=0 and bpx and ttl<100 then
				ttl=0
				for i=0,3 do
					local flk=atbl(blts,new_blt(x+8,y-8,1,6,0,-1+i*.67,-2.5))
					flk.pwr=1
				end
				wpncost"1"
				sfx"59"
			elseif kblt>=0 and wpn!=2 then
				ttl=0
			else
				ttl=ttl%61+2
				for b in all(blts) do
					pwr=2
					if b.man!=man and overlap(_ENV,b) then
						if b.pwr>=0 then b.ttl=0 end
						if kblt>=0 then wpncost(b.pwr/3) end
						pwr-=abs(b.pwr)
						if pwr<=0 or (man==plr and gkwpn"1"<=0) then ttl=0 end
						sfx"54"
					end
				end
			end
			if xv==0 then
				x,y=man.x-6,man.y+4
			end
		end,
		function(_ENV) --f
			local bp=man==boss or btn"5"
			if not bp then ttl-=max(0,ttl-16)*2 end
			y,man.flp=man.y-3 or y,sgn(xv)
			man.shoot=2
			if tfget(x+3.5+xv*200,y-4)>=0x42 then
				if bp and man.hook<69 and abs(man.x-x)>8 then
					man.yv,man.hook,man.lad,ttl=-.125,xv*200,false,16
					--cut if low on tokens
					--x-=xv
				else
					ttl,man.hook=0,0
				end
			else
				x=man.x+2+sin(ttl/xv*800)*56
			end
		end,
		fblnk, --s
		function(_ENV) --globe flake
			yv+=.125
		end,
		fblnk, --pop
		fblnk, --pellet
		fblnk, --bubble
	}
	bdrw={
		function(_ENV) --p
			spr(108,x,y-4)
		end,
		function(_ENV) --k
			spr(27,x,y-h,2,1,xv<0)
		end,
		function(_ENV) --c
			for i=0,3 do
				local ang=i/-4+ttl/60
				spr(18,x+sin(ang)*10+6,y+cos(ang)*10-12)
			end
		end,
		function(_ENV) --f
			spr(35,x,y-h,1,1,xv<0)
			line(man.x+4+xv*600-tonum(xv>0),man.y-6,x+4-xv*200-tonum(xv<0),y-3,6)
		end,
		function(_ENV) --s
			spr(36+fdiv(gt,3)%3*2,x-4,y-11,2,2,xv<0)
		end,
		function(_ENV) --globe flake
			spr(18,x-2,y-4)
		end,
		function(_ENV) --pop
			circfill(x,y,(ttl%15)/3,15)
			circfill(x,y,(ttl%15)/3-2,7)
		end,
		function(_ENV) --pellet
			spr(5,x-2,y-3)
		end,
		function(_ENV) --bubble
			local s=sin(gt/21)
			palrst()
			circ(x+5,y-4,6.5+s,12)
			pset(x-s+2,y-7-s,7)
		end,
	}
	return env{
		x=nx,
		y=ny,
		kblt=nkblt,
		xv=nxv or 0,
		yv=nyv or 0,
		w=split"7,15,19,7,7,2,7,1,9"[t],
		h=split"5,4,21,6,10,2,5,1,9"[t],
		ttl=300,
		pwr=split"1,-4,2,2,3,2,0,1,3"[t],
		man=nkblt>=0 and plr or boss,
		motion=function(_ENV)
			x+=xv
			y+=yv
			ttl-=1
			if plr then plr.blim+=max(0,kblt) end
			if offscreen(_ENV) then ttl=0 end
			if pwr!=0 then
				--damage enemies
				for e in all(nmes) do
					if kblt>0 and overlap(_ENV,e) then
						--negative pwr pierces
						if e.dink and pwr>=0 then
							pwr=0
							if abs(xv)<.1 then
								ttl-=max(0,ttl-16)*2+fdiv(t,5)*100
								wpncost(3,3,t)
							else
								xv*=-1
								yv=abs(xv)*-1
							end
							sfx"54"
						else
							e.hit=3
							local ohp=e.hp
							e.hp-=abs(pwr)
							pwr-=min(3,ohp)
							if pwr<=0 then ttl=0 end
							if e.hp<=0 then
								--spawn pop particle
								atbl(blts,new_blt(e.x+e.w/2,e.y-e.h/2,0,7))
								--spawn item
								atbl(xtrs,new_xtr(e.x+2,e.y-8,2,mget(112+rnd"16",23)))
							end
							if t==3 then
								e.ice+=240
								if pwr<=0 then
									wpncost"3"
								else
									wpncost"1"
									pwr=2
								end
							elseif t==6 then
								e.ice+=60
							end
							sfx"57"
						end
					end
				end
				--damage player
				if kblt<=0 and plr and plr.invul<=0 and overlap(_ENV,plr) then
					plr.hp-=abs(pwr)+tonum(man==boss)
					if plr.hp>0 then
						plr:hurt()
					end
				--damage boss
				elseif kblt>0 and boss and overlap(_ENV,boss) then
					wpncost(3,3,t)
					ttl=0
					if boss.invul<=0 then
						boss.invul=35
						kwpn[3][1]-=split"121131k,131121c,125223f,111311s,111211h"[boss.t][t]
						--kwpn[3][1]-=split"121131k,131121c,125222f,111311s,111211h"[boss.t][t]
						if gkwpn"3"<=0 then
							if stg>=5 then
								atbl(xtrs,new_xtr(boss.x,boss.y,2,6))
								loadmus(stg)
							else
								music"-1"
								_g.cntdwn=550
								if dget(4+stg)<0 then
									dset(0,dget"0"+1)
								end
								dset(4+stg,16)
							end
							explode(boss)
							_g.boss,_g.nmes=nil,{}
							sfxa"47,3"
						else
							sfx"57"
						end
					end
				end
			end
		end,
		
		init=bspw[t],
		update=bupd[t],
		draw=bdrw[t],
	}
end

--enemy class
--metall-8, shield attacker px9,
--globe trotter, gabyohm,
function new_nme(nx,ny,t,s)
	espw={
		fblnk, --met
		function(_ENV) --shield atk
			xv,hp=-1,4
		end,
		function(_ENV) --globe
			hp,pwr=15,7
		end,
		function(_ENV) --gabyohm
			hp,xv=4,-1
			function smoke()
				atbl(blts,new_blt(x+5.5,y-5,-.5,7,2))
				blts[#blts].ttl=15
			end
		end,
		fblnk, --bubble
	}
	eupd={
		function(_ENV) --met
			if tmr!=0 then
				tmr+=1
				h=11
				if tmr==20 then
					for i=-3,-1 do
						atbl(blts,new_blt(x+5,y-3,-1,8,0,sin(i/8)*flp,cos(i/8)))
					end
				end
				if tmr>35 then tmr=-12 wait=50 end
			elseif plr then
				h,wait,flp=5,max(0,wait-1),sgn(plr.x-x)
				if wait<=0 and abs(x-plr.x)<39 then
					tmr=1
				end
			end
			dink=tmr==0
		end,
		function(_ENV) --shield atk
			tmr+=1
			if tmr>72 then
				xv=0
				if tmr==79 then flp*=-1 end
				if tmr>=86 then tmr=0 xv=flp end
			end
			x+=xv
			dink=plr and ((plr.x<x and xv<0) or (plr.x>x and xv>0))
		end,
		function(_ENV) --globe
			if tmr>=11 then
				if plr then
					yv,xv=-2,mid(-1,(plr.x-x)/34,1)
				end
				tmr=0
			end
			y+=yv
			yv+=.125
			flp=sgn(yv)
			for j=0,2 do
				for i=0,1 do
					while tfget(x+i*w,y-j*7)>=0x42 do
						y-=flp
						if yv>.7 then
							sfxa"34,-1,0,1"
							sfx"51"
							for i=0,3 do
								atbl(blts,new_blt(x+5,y-20,-1,6,0,-1+i*.67,-1.67))
							end
						end
						yv,xv=0,0
						tmr+=.75
					end
				end
			end
			x+=xv
			for j=0,2 do
				for i=0,1 do
					while tfget(x+i*w,y-j*7)>=0x42 do
						x-=sgn(xv)
					end
				end
			end
		end,
		function(_ENV) --gabyohm
			flp+=1
			if hp<4 and hp>0 then
				wait+=4-hp
				hp=4
				if wait>=3 then
					if tmr<=0 then
						sfx"59"
						smoke()
					end
					tmr=300
				end
			end
			if tmr>0 then
				tmr-=1
				flp,wait=0,3
				if tmr%25==0 then
					smoke()
				end
				if tmr<=0 then
					wait=0
				end
			elseif plr then
				x+=xv/mid(1,abs(plr.y-y),4)
				local switch=false
				for i=0,1 do
					if tfget(x+i*w,y)<0x42 or tfget(x+i*w,y-1)>=0x42 then
						switch=true
					end
				end
				if switch then
					x-=xv
					xv*=-1
				end
			end
		end,
		function(_ENV) --bubble
			dink,w=true,hp*2+12
			h,x,y=w,boss.x+4-w/2,boss.y-4+w/2
			if pwr<4 then
				hp+=1
				if hp>=16 then
					pwr=4
				end
			end
		end,
	}
	edrw={
		function(_ENV) --met
			local hat=split"5,4,3,2,1,4,7,5,6"[5+min(4,ceil(tmr/4))]
			spr(58,x-2,y-5,2,1,flp<0)
			spr(42,x-2,y-5-hat,2,1,flp<0)
		end,
		function(_ENV) --shield atk
			local dip=fdiv(x,4)%2
			spr(xv!=0 and 44 or 46,x-2,y-h+dip,2,2,flp<0)
			if dip>0 then
				for i=1,2 do
					--dip*x if low on tokens
					spr(29,x+2+flp*-7,y-7.5*i,1,1,flp<0)
				end
			end
		end,
		function(_ENV) --globe
			local fh=fdiv(tmr,3)*2
			spr(26,x+2,y-6)
			spr(10,x+2,y-14+fh)
			spr(8,x-2,y-30+fh,2,2)
		end,
		function(_ENV) --gabyohm
			local gpal=split"11,3,9,4,8,2,12,13,1,0"
			pal(11,gpal[1+wait*2+fdiv(flp,6)%2+fdiv(tmr,75)])
			spr(30,x-2,y-7,2,1)
		end,
		function(_ENV) --bubble
			local s=sin(boss.shoot/51)
			local bx,by,br=x+w/2,y-w/2,
			hp*.75+2.5+s
			circ(bx,by,br*2,12)
			pset(bx-br,by-br,7)
		end,
	}
	return env{
		x=nx,
		xv=0,
		y=ny,
		yv=0,
		w=11,
		h=split"6,15,28,3,6"[t],
		tmr=0,
		dink=false,
		flp=-1,
		hp=1,
		hit=0,
		pwr=3,
		wait=0,
		sp=s,
		ice=0,
		check=function(_ENV)
			--hurt player
			if plr and plr.invul<=0 and overlap(_ENV,plr) then
				plr.hp-=pwr
				if plr.hp>0 then
					plr:hurt()
				end
			end
			if offscreen(_ENV) then hp=0 end
		end,
		init=espw[t],
		update=eupd[t],
		draw=edrw[t],
	}
end

--extra class
--spawners,items,yoku blocks
--boss doors,w-plate,surge arcs
--checkpoints,boss spawner,wily
function new_xtr(nx,ny,t,nxp,nttl)
	xspw={
		function(_ENV) --spawner
			x+=2
		end,
		function(_ENV) --item
			y+=8
			x+=xp%2
			w,h=7-xp%2*2,xp>5 and 7 or 5
			if xp==0 or (xp>=7 and dget(stg+9)>=1) then ttl=0 end
		end, 
		function(_ENV) --yoku block
			ttl,wait,w,h=nxp*60,usp"60,7,2"
		end,
		function(_ENV) --boss door
			h,yv=xp,false
			if plr.x>x then can=false end
		end,
		fblnk, --w-plate
		function(_ENV) --surge arc
			x+=3
			y+=3
			yv,ttl=-2,xp*90+1
		end,
		fblnk, --checkpoint
		fblnk, --boss spawner
		fblnk, --wily
	}
	xupd={
		function(_ENV) --spawner
			if can and yv and not offscreen(_ENV) then
				atbl(nmes,new_nme(x,y+8,xp,_ENV))
				can=false
			end
			yv=offscreen(_ENV)
		end,
		function(_ENV) --item
			ttl-=1
			y+=yv
			yv+=.125
			for i=0,1 do
				while tfget(x+i*w,y)>=0x42 do
					y-=1
					yv=0
				end
			end
			
			if plr and overlap(plr,_ENV) then
				ttl=0 
				if xp>=7 then
					_g.etnk+=1
					dset(stg+9,1)
					dset(1,etnk)
					sfx"55"
				elseif wpn>0 or xp>=5 then
					fillbar(xp<5 and 1 or 2,8-xp%2*6)
					plr.hp=gkwpn"2"
				end
			end
			if ttl<=360 and offscreen(_ENV) then
				ttl=0
			end
		end,
		function(_ENV) --yoku block
			if wait>0 then
				wait-=1
			else
				ttl+=1
			end
			if ttl>=361 then
				ttl=1
				mset((x+w/2)/8,y/8,252)
				if not offscreen(_ENV) then
					sfxa"34,3"
				end
			end
			if ttl>=121 then
				mset(x/8,y/8,197)
			elseif plr and plr.y>y and overlap(plr,_ENV) then
				--set unsolid,more lenient
				fset(252,0x2)
			end
		end,
		function(_ENV) --boss door
			if plr then
				if x>cl then
					if plr.x&-1>x-8 then
						if boss then
							plr.x=x-8
							--cut if low on tokens
							--plr.slide=1
						elseif can then
							_g.blts,can={},false
							sfx"62"
							while xp>0 do
								xp-=1
								wait"6"
							end
							for i=0,63 do
								if plr then
									_g.cx+=2
									plr.x+=.375
									wait(0,true)
								end
							end
							sfx"62"
							while xp<h do
								xp+=1
								wait"6"
								mset(x/8+1,y/8+xp,236)
							end
							_g.cl,_g.cr=x+8,crr
						end
					elseif x-120<cr then
						_g.cr=x-120
					end
				end
			end
		end,
		fblnk, --w-plate
		function(_ENV) --surge arc
			--go in xdrw if low on tokens
			ttl=ttl%180+1
			if ttl%4==0 then
				xp=6-rnd"5"
				w=xp+rnd(7-xp)+1
				yv*=-1
			end
		end,
		function(_ENV) --checkpoint
			if not offscreen(_ENV) then
				_g.cps,_g.cpl,ttl=seg,x,0
			end
		end,
		function(_ENV) --boss spawner
			if not offscreen(_ENV) then
				_g.boss,ttl=new_boss(cl+96,y-1,xp),0
				loadmus(7)
			end
		end,
		function(_ENV) --wily
			if plr.x>944 then
				xp,plr.blim=38,300
				if ttl==32767 then yv=-2 music"63" end
				ttl-=1
				yv+=.15
				y+=yv
				if y>=ny then
					y,xp=ny,4+fdiv(ttl,10)%2*2
					if ttl==32400 then
						_g.cntdwn,_g.stg=240,6
						sfx"48"
					end
					xp-=min(cntdwn*4,4)
				end
			end
		end,
	}
	xdrw={
		fblnk, --spawner
		function(_ENV) --item
			if ttl>60 or fdiv(ttl,4)%2!=0 then
				pal(13,kcol[2])
				pal(12,kcol[3])
				spr(xp+fdiv(ttl,8)%2*16,x,y-h)
			end
		end,
		fblnk, --yoku block
		function(_ENV) --boss door
			for i=1,xp do
				for j=0,1 do
					spr(236,x+j*8,y+i*8)
				end
			end
		end,
		function(_ENV) --w-plate
			spal(split("1,0,0,0,0,0,7,0,0,0,0,9,4;13,0,0,0,0,0,7,0,0,0,0,6,12;0,0,0,0,0,0,7,0,0,0,0,14,1;2,0,0,0,0,0,7,0,0,0,0,14,8;0,0,0,0,0,0,7,0,0,0,0,12,1",";")[xp])
			spr(170,x,y,2,2)
		end,
		function(_ENV) --surge arc
			if ttl<=60 then
				line(x,y,x+xp,y+yv,15)
				line(x+xp,y+yv,x+w,y-yv)
				line(x+w,y-yv,x+9,y)
			end
		end,
		fblnk, --checkpoint
		fblnk, --boss spawner
		function(_ENV) --wily
			spr(136+xp,x,y-16,2,2,ttl<32767)
		end,
	}
	return env{
		x=nx,
		y=ny,
		w=11,
		h=5,
		ttl=nttl or 360,
		xp=nxp,
		can=true,
		yv=nttl and 0 or -1.33,
		
		init=xspw[t],
		update=xupd[t],
		draw=xdrw[t],
	}
end

--player class
function new_plr()
	return env{
		x=cpl+60,
		xv=0,
		y=103,
		yv=0,
		air=false,
		water=.125,
		img=1,
		anim=0,
		flp=1,
		slide=1,
		step=0,
		w=7,
		h=11,
		lad=false,
		shoot=0,
		nostep=false,
		inslide=false,
		blink=0,
		lflp=1,--also death flag if 0
		warp=145,
		warpdir=-1,
		blim=0,
		kb=-1,
		invul=0,
		hp=16,
		hook=0,
		
		update=function(_ENV)
			
			function fcol(ay,lim,xst)
				ay,lim,xst,f=ay or 0,lim or h,xst or 0,0
				for hi=0,lim,lim/2 do
					for wi=xst,w,w do
						local t=tfget(x+wi,y+ay-hi)
						if t>f then f=t end
					end
				end
				if f==0 then return 2 end
				return f
			end
			
			function scol(ay)
				if fcol(ay)==194 then hp=0 end
				return fcol(ay)>=64 or fcol(ay,.01)==42
			end
			
			function lcol(ay,lim,xst)
				return fcol(ay,lim,xst)&34==34
			end
			
			local nohook=hook==0
			if not nohook then _g.lr=hook end
			
			local kblim=kb<=0 and blim<100
			if not kblim then _g.lr=0 end
			
			invul=max(0,invul-1)
			
			--grab ladder
			if not lad and kblim and nohook and ((not air and lcol(1,nil,4) and btn"3") or (lcol(0,nil,4) and btn"2")) then
				lad,air,yv,x=true,false,0,fdiv(x+4,8)*8
			end
			
			--warp
			if warp>0 then
				while scol() do y-=8 end
				warp+=warpdir
				inslide=warp>0--disable shoot
				if warpdir<0 and warp==7 then sfx"58" end
			--on ladder
			elseif lad then
				if shoot<=0 then
					y+=ud*.65
				end
				--let go
				if ud==0 and bpo or not lcol() then lad=false end
				slide,inslide=1,false
			else
				--knockback,invul
				if kb>0 then
					kb-=1
					x-=flp*.325
					if not nohook then hook=999 end
					if scol() then x+=flp*.325 end
					_g.lr,_g.ud=0,0
				end
				
				--gravity
				local grv=.125*(fcol()%8)/2
				yv+=grv
				y+=min(3.5,yv)
				
				if water!=grv and y<112 then sfx"59" end
				water=grv
				
				--floor col;push out
				if scol() then
					while scol() do
						y-=sgn(yv)
					end
					yv=0
				end
				
				--land/jump
				local ycol=scol"1" and yv>=0
				if ycol then
					--landing sound
					if air and y<127 then sfx"61" end
					--🅾️ pressed
					if bpo and kblim and kblim then
						--holding down, slide
						if btn"3" then
							if slide<2 then
								slide=25
							end
						--jump otherwise
						else
							yv,ycol=-2.613343,true
						end
					end
				else
					--fell off ledge, move down
					--to prevent walking across
					--single tile gaps
					if not air and nohook then y+=.875 end
					--🅾️ not held, cap yv
					if not btn"4" then
						yv=max(0,yv)
					end
					slide=1
				end
				air,inslide=not ycol,slide>1
				
				--stepping
				step=(air or inslide) and 6 or mid(0,step+abs(lr)*2-1,6)
				
				--set direction
				if lr!=0 then
					--cancel slide if turning
					if flp!=lr then slide=1 end
					flp=lr
				end
				
				--movement velocity
				nostep=step>=6
				if nostep then
					if inslide then
						slide=max(1,slide-1)
						--stay in slide under tiles
						if scol"-1" then
							slide=max(2,slide)
						end
					end
					xv=.6875*(inslide and flp or lr)*min(2,slide)
				else
					xv*=fcol"1"==82 and .966 or 0
				end
				
				--hitbox height when sliding
				h=inslide and 7 or 11
				
				--inching forwards
				local blr=bnp"1"-bnp"0"
				if not nostep and blr==flp and kblim then
					x+=blr
					if scol() then x-=blr end
				end
				
				--apply velocity, collide
				x+=xv
				if scol() then
					x=x&-1
					while scol() do
						x-=sgn(xv)
					end
					xv,slide=0,0
					if not nohook then hook=999 end
				end
				x=mid(x,cr+127-w,cl)
			end
			
			if y>116 then
				--downward transition
				if pitr and x>=cr then
					_g.seg+=1
					loadseg"-1"
				elseif pitl and x<cl+128 then
					_g.seg-=1
					loadseg"-1"
				end
			elseif lad and y<6 then
				--upward transition
				_g.seg+=1
				loadseg"1"
			end
			
			--into the pit
			if y>127 then hp=0 end
			
			--shooting
			if not inslide and blim<3 and kblim and (gkwpn"1">0 or wpn<1) and bpx and nohook then
				shoot=16
				--energy cost
				wpncost(split"0,1,0,1,1"[wpn+1])
				sfx(49+wpn)
				if lr!=0 then flp=lr lflp=flp end
				atbl(blts,new_blt(x+flp*8,y-3,1+wpn*2,wpn+1,flp,flp*2))
			end
			
			--update shoot,camera,and hud
			shoot,_g.cx,kwpn[2][1],
			kwpn[1]=max(0,shoot-1),
			mid(x-60,cr,cl),
			hp,kwpn[wpn+4]
			
			--die if no health
			if hp<=0 then
				lflp=0
			end
			
			--scheduled execution
			if lflp==0 then
				music"-1"
				wait"30"
				sfx"47"
				_g.plr,_g.cntdwn=nil,180
				if y<=133 then
					explode(_ENV)
				end
			end
			
			if hook<69 then hook=0 end
			
			--pause
			if btnp"6" and warp<1 and cntdwn<=0 and kblim then
				?"⁶!5f30\1"
				_g.pause=true
				sfx"46"
			end
			
			--fanfare/warp out
			if cntdwn==350 then music"63" end
			blim=100*tonum(cntdwn>0 and cntdwn<=350)
			if cntdwn==90 then
				warpdir,warp=.75,.0001
				sfx"63"
			end
		end,
		
		hurt=function(_ENV)
			lad,kb,invul,slide,yv=false,usp"28,88,1,0"
			sfx"56"
		end,
		
		draw=function(_ENV)
			palrst()
			--frames
			img=1
			local look=stg==6 and cntdwn<180
			if lr!=0 or look then
				if nostep or look then
					anim+=.125
					anim%=4
					img=split"2,3,4,3"[flr(anim)+1]
					if look then img+=25 end
				else
					img=8
				end
			else
				anim=0
				blink+=1
				blink%=98
			end
			if air then img,anim=5,0 end
			if inslide then img=22 end
			if lad then 
				--flipping animation
				step+=abs(ud)
				if step>=9 then
					step=0
					lflp*=-1
				end
				
				img=fcol"-4"<32 and 7 or 6
			end
			if kb>0 then img=18 end
			if warp>0 then
				img=split"21,19,20,19"[min(fdiv(warp,3)+1,4)]
			end
			
			if shoot>0 and img<9 then
				img+=8
				--alt pose
				if air and wpn%2==1 then img=26 end
			end
			
			if img!=1 then blink=0 end
			if blink>=89 then img=17 end
			
			if fdiv(invul,2)%2==1 then
				if kb!=0 then pal(0,7) else img=23 end
			end
			cspr(nil,img)
			spal"0"
			local bflp=flp<0
			if lad and shoot<=0 then bflp=lflp<0 end
			pal(13,kcol[2])
			pal(12,kcol[3])
			spr(48,x-12,y-9,4,1,bflp)
			spr(0,x-4,y-14-max(0,warp*9-80),2,3,bflp)
			
			pal(0,0)
			
			if warpdir<0 and warp>24 and warp%12>5 then
				printd("ready",cx+54,53)
			end
		end,
	}
end

--boss class
function new_boss(nx,ny,nt)
	return env{
		t=nt,
		x=nx,
		y=-32,
		yv=1,
		w=7,
		h=11,
		headplus=split"32,34,48,50,-62"[nt],
		idle=split"24,1,1,25,1"[nt],
		xv=0,
		img=1,
		flp=-1,
		invul=0,
		wait=0,
		ptrn=0,
		shoot=0,
		anim=0,
		hook=0,
		fire=function(_ENV)
			sfx(49+t)
			shoot=16
			atbl(blts,new_blt(x+flp*8,y-3,-1,t+1,flp*2.6667,flp*2))
		end,
		altfire=function(_ENV,u)
			sfx"49"
			atbl(blts,new_blt(x+4+flp*8,y-3,-1,8,flp,flp,-.7071*u))
		end,
		xybound=function(_ENV)
			x,y=mid(cl+8,x,cl+112),min(ny,y+yv)
		end,
		bupd={
			function(_ENV) --km
				local pf=plr and plr.x-x or rnd"112"+cl+8-x
				wait-=1
				if y>=ny then
					img=1
					xv,flp=0,plr and sgn(pf) or flp
					if wait==10 then
						if ptrn%3==0 then
							if ptrn%9==0 then
								yv,wait=-2.3333,30
							else
								fire(_ENV)
							end
						else
							wait=-10
						end
					elseif wait<=-10 then
						yv=split"-3,-2.25,-2.75,-2.8,-2"[ptrn%5+1]
						intro=ceil(yv*-13.6667)
						xv,wait,flp=pf,20+intro,sgn(pf)
						xv/=intro*(ptrn%2+1)
						ptrn+=1
					end
				else
					img=5
					x+=xv
					yv+=.15
					if wait==15 then
						fire(_ENV)
					end
				end
				xybound(_ENV)
			end,
			function(_ENV) --cm
				local sh=blts[1]
				if wait==0 then
					fire(_ENV)
				end
				wait+=1
				if wait>-89 then
					x+=flp*.6
					yv+=.125
				elseif sh then
					if wait==-89 and sh.yv==0 then
						deli(blts,1)
					elseif wait%30==0 then
						ptrn+=1
						local pf=ptrn%2+1
						sfx"59"
						for i=0,3 do
							atbl(blts,new_blt(x+2,y-8,-1,6,0,(i*0.8889-1.3333)/pf,-1.67))
						end
					end
				end
				img=y>=ny and -1 or 5
				if wait>0 then
					local px=abs(cl+60-x)
					if y>=ny and px<14 then
							yv=-2.125
					elseif px<1 and sh and sh.kblt<0 then
						wait,yv=-200,0
					end
				end
				local ox=x
				xybound(_ENV)
				if ox!=x then flp*=-1 wait=0 end
			end,
			function(_ENV) --fm
				if hook!=0 then
					yv=-.0625
					if ptrn<0 or wait>150 then
						xv,hook=hook/2,0
					elseif wait>90 and wait%20==0 then
						altfire(_ENV,2)
					end
				end
				if wait==0 then
					yv,xv=-1.3333,cl+60-x
					xv/=42
				end
				if wait==5 or wait==20 then
					img=30
					altfire(_ENV,tonum(wait==20))
				end
				if wait==38 then img=1 end
				if plr and wait==65 then flp=sgn(plr.x-x) end
				if wait==80 then
					fire(_ENV)
					ptrn=-sgn(ptrn)
					yv,xv,img=2*ptrn,0,5
				end
				wait+=1
				if y>=ny and yv>0 then
					img=1
					if wait>175+ptrn*15 then
					flp*=-1
					wait=-21
				end
				else
					yv+=.0625
					x+=xv
				end
				xybound(_ENV)
			end,
			function(_ENV) --sm
				local ox,pf=x,plr and plr.x-x or flp*-1
				xybound(_ENV)
				if y>=ny then
					if ox!=x then flp=sgn(pf) end
					if img%6==5 and ptrn%5==0 then fire(_ENV) end
					wait+=1
					img,xv=-1,0
					x+=flp*.6875
					if plr and bpx or wait>50 then
						flp,wait,yv=sgn(pf),0,-2.3333
						if abs(pf)<48 and ptrn%4<3 then
							xv=-flp
							fire(_ENV)
						else
							xv=flp
						end
						ptrn+=1
					end
				else
					img=5
					yv+=.1333
					x+=xv
					if abs(yv)<.066 and ptrn%5!=0 then fire(_ENV) end
				end
			end,
			function(_ENV) --hd
				wait+=1
				if ptrn>=21 then
					x+=flp*.6
					y=68
					if wait>=80 then
						atbl(nmes,new_nme(x,y,5,_ENV))
						ptrn,wait,shoot=usp"0,0,30"
					end
				elseif ptrn>=20 then
					x+=flp*2
					if offscreen(_ENV) then
						ptrn+=1
						flp*=-1
						x,wait=cl+60-96*flp,0
					end
				else
					y+=sin(shoot/120)/8
					if wait>25+gkwpn"3" then
						if #nmes>0 then
							nmes[1].hp-=1
							ptrn,wait=16-nmes[1].hp,0
							local ypat=split"78,56,75,77,52,75,58,71,70,69,77,61,66,75,69,70,70,70,70"[ptrn]
							atbl(blts,new_blt(x,ypat,-1,9,0,flp*1.5))
						elseif wait>80 then
							sfx"59"
							ptrn=20
						end
					end
				end
			end,
		},
		
		update=function(_ENV)
			if plr then plr.blim=100 end
			xv+=1
			_g.blts={}
			if t<5 then
				yv+=.125
				img,y=idle,min(ny,yv*xv)
			else
				yv+=min(16/xv-.17,.75)
				x,y,h,shoot=max(cl+96,cl+136-yv),68,7,30
				if xv==70 then
					atbl(nmes,new_nme(x,y,5,_ENV))
				end
			end
			if xv>=90 and plr then
				fillbar(3,20)
				update,yv=bupd[t],0
			end
		end,
		
		draw=function(_ENV)
			palrst()
			invul=max(0,invul-1)
			pal(0,fdiv(invul,2)%2*7)
			shoot=max(0,shoot-1)
			if t>=5 then
				shoot+=2
				spr(34,x,y-h,1,1,flp<0)
			else
				if img<1 then
					anim+=.125
					anim%=4
					img=split"2,3,4,3"[flr(anim)+1]
				end
				local mimg=img
				if shoot>0 then mimg+=8 end
				if t%2==1 and mimg==13 then mimg=26 end
				if mimg<=1 then mimg=idle end
				cspr(headplus,min(mimg,30))
				local kcol=kwpn[t+4]
				pal(13,kcol[2])
				pal(12,kcol[3])
				pal(1,0)
				spr(48,x-12,y-9,4,1,flp<0)
				spr(0,x-4,y-14,2,3,flp<0)
				if shoot<=0 and t==1 then
					spr(27,x-4,y-14,2,1,flp<0)
				end
				if xv>=154 then
					local name=split"chop,cryo,fish,surge"[t].." man"
					printd(sub(name,1,fdiv(xv-150,4)),64-#name*2,63)
				end
			end
		end,
	}
end
__gfx__
0eee0ee000ee0eee00000000e0000eeee000000ee0000eeeee0000ee0000000eeeeeee7777eeeeee013003100000000000000000000000000000000000000000
e0eee00eee0ee0ee000000000dddd0ee0d0cc0d00f77f0eee0ffff0e0d000d0eeeee77eeee77eeee0301103011111100000440000000000000000000000aa0dd
ee0e00000000ee0e00000000d0cc0deed0cccc0d077770ee0ff77ff00d0ccd0eeee7eee77eee7eee0305103000110000000000000000000000000000000ad0dd
ee0000000ee000e000000000d0cc0deed0cccc0d077770ee0f7777f00d000d0eee7eeee71eeee7ee01888810001100144404700777770aaaaa00aa00aa0dd0dd
000000ee000e000eeeeeeeee0dddd0ee0d0cc0d00f77f0ee0f7777f00d0ccd0eee7eee7317eee7eee018810e002200550008808800880bb00bb0bb00bb0ee0ee
e00000ee0e0e000eeeeeeeeee0000eeee000000ee0000eee0ff77ff00d000d0ee7eeee3771eeee7ee081080e003300660009909900990cc00cc0cc00cf0ff0ff
e00000eeeeee000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ffff0e0dcccd0ee7eeee7717eeee7eee0510ee003300660009900999990cc00cc00cccff0ff0ff
ee00e00e00e000e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000ee0000000ee7eee733717eee7eee0650ee0000000000000000000000000000000000000000
0ee0ee0000e00eeeee7e7eeee0000eeee000000ee0000eeeee0000ee0000000ee76ee133111ee67eee0510eee000000000000000eeeeeeeeeeeeeeeeeeeeeeee
e0ee0eeeee00e0eee6e7e6ee0cccc0ee0c0dd0c0000000eee0ffff0e0dcccd0eee767774477767eeee0650eee066660666667760eeeeeeeeeeeeeeeeeeeeeeee
ee0ee0eeee00ee0e7e676e7ed0dd0deed0dddd0d000000ee0f0000f00dcccd0eee766777777667eeee0510eee00000066667760eeeeeeeeeeeeeeeeeeeeeeeee
eee0e00000ee0ee0e77677eed0dd0deed0dddd0d000000ee0f0000f00dcccd0eee000000000000eeee0650eeeeeeee06677600eeeee88eeeeee00e0000e00eee
0eee00e00ee000ee7e676e7e0cccc0ee0c0dd0c0000000ee0f0000f00dcccd0ee02477077077420eee0000eeeeeeee000000eeeee8870eeeeee0709999070eee
e0eee0ee0000000ee6e7e6eee0000eeee000000ee0000eee0f0000f00dcccd0ee02447744774420ee065510eeeeeeeeeeeeeeeee87770eeeeee0000000000eee
ee0ee0e00e00000eee7e7eeeeeeeeeeeeeeeeeeeeeeeeeeee0ffff0e0dcccd0ee00000000000000e05551110eeeeeeeeeeeeeeeee8870eeeee09970bb07990ee
eee0e00000e0eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000ee0000000eeeeee013310eeeee00000000eeeeeeeeeeeeeeeeeee88eeeee000000000000ee
0eee0e0000ee0eeeee0000eeeeeeeefeeeeeeef7feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000eeeeeeee000000000eeeeeee0000000000eeee
e0eee00000eee0eee0ccdd0eeeeeeffeeeeeef7eeeeeeeeeeeeeffeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00999700eeeeee0788007870eeeeee0222227880eeee
ee0eee000e0eee0e0ccd99d0fffee00feeeef7ef77feeeeeeeef7efeeeeeeeeeeef7eeeeeeeeeeeeeee0999999790eeeee0078800870eeeeee00888027880eee
eee0eee0eee0eee00dd99790f0ffeeefeeee77f7777feeeeeee7eeeeffeeeeeeef7efeeeeeeeeeeeeee0999999990eeeee70078888870eeeeee8778802780eee
0eee0eee0eee0eee0dd99990fff0feefeef77f777777feeeeef7eee777feeeeee7feeeeeccceeeeeeee0000909000eeeee00880000000eeeee87777702800eee
e0eee0eee0eee0ee0ccd99d0000e0ff0eeef777777777eeeee77ee77777feeeef7eeeccccccceeeeee099999999990eeee708077777780eeeee87788020870ee
ee0eee0eee0eee0ee0ccdd0eeeeee00eef77777777777eeeee77eef77777eeeef7eeeeeccccceeeeee000000000000eeee080780000000eeeeee8880080700ee
eee0eee0eee0eee0ee0000eeeeeeeeeeeeef777777777eeeee77ef77777feeeef7eeeecccccceeeeeeeeeeeeeeeeeeeeee07870707070eeeeeee020007870eee
0eee0eee0eee0eee0eee0eee0eee0eeeeef77f777777feeeeef7eee777feeeeee7feeeeeccceeeeeeeee00777770eeeeee07870770770eeeeeee020007870eee
e0eee0eee0eee0eee0eee000e0eee0eeeeee77f7777feeeeeee7eeeeffeeeeeeef7efeeeeeeeeeeeeee0907070700eeeee080780000000eeeeee8880080700ee
ee0eee0eee0eee0eee0e0000000eee0eeeeef7ef77feeeeeeeef7efeeeeeeeeeeef7eeeeeeeeeeeeeeee00770770eeeeee708077777780eeeee87788020870ee
eee0eee0eee0eee0eee00eee0e00eee0eeeeef7eeeeeeeeeeeeeffeeeeeeeeeeeeeeeeeeeeeeeeeeeee0990090090eeeee00880000000eeeee87777702800eee
0eee0eee0eee0eee0eee0e0e000e0eeeeeeeeef7feeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee099990009990eeee70078888870eeeeee8778802780eee
e0eee0eee0eee0eee0ee000000eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000eeee0078807870eeeeee00888027880eee
ee0eee0eee0eee0eee0ee000ee0eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0788000870eeeeee0222227880eeee
eee0eee0eee0eee0eee0eee0eee0eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000eeeeeee0000000000eeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeeeeeeeeeeeeeeeeee00eeeeeeeeeeeeeeeeeeee0dcd0eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ccc0eeeeeeeeeeeeeeeee0dd0eeeeeeeeeeeeeeeeeee0dd00eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0dcc0d0eeeeeeeeeeeeeee0dd0eeeeeeeeeeeeeeeeeee0dcd0eeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeee00eeeeeeeee0eeeeeeeeeeeeeeeeeeeee0ddccddd0eeeeeeeeeeeeee0d0eeeeeeeeeeeeeeeeeeee0dccdeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee0dd0eeeeeee0d0eeeeeeeeeeeeeeeeeeee00dddd0000eeeee000eeeee0d0eeeeeeeee0000eeeeeeee0dcd0eeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee0dd0eeeeeee0d0eeeeeeeeeeeeeeeeeee0dcc00cccdd0eee0ddd0eeee0d0eeeeeeee0cccc0eeeeeee0dd00eeeeeeeeeeeeeeeee
ee0eeeeeeeeee00eeeeeeeeee0ddd0eeeeee0d0eeee00eeeeeee00eee0dddcccc000dd0eee0dd0eeeee00eeee0000dddddd0000ee0dcd0eeeeeeeeeeeeeeeeee
e0d0eeeeeeee0dd0eeee0eeeee0dc0eeeee0d0eeee0cc0eeeee0cd0ee0dd0ddddccc0d0eee0d0eeeeee0c0ee0ddddcccddcdddd0e0dccdeeee00eeeeeeee0eee
0ddd0eeeeee0ddd0eee0d0eeeee0cc0000c00eeee0dccc0000ccddd0ee000dddcc0cc0eeee00000eeeee0cc0e0dccdddddcccd0eee0dcd0ee0dd0eeeeee0dc00
0ddd0c00000cddd0cdddd0eeeeee0ccccc00eeee0ddd0cccccc0ddd0eeee0cddc0ccd0eeee0cd0d0eeeee0ccee0cccdccdccc0eeee0dd00ee0ddc0ccee0dd0cc
0d000cccc0cccd0ecdddd0eeeeeee0cccc00eeee0ddd00cccc000dd0eeee0cc000dddd0ee0ccddd0eeeee0cceee0dddccdcd0eeee0dcd0eee00000c0ee0dd0dd
00dd0ddddc0000ee00000eeeeeeee0ddddcc0eee0dd0e0ddddcc000eeeee0cd0ee00000ecdc0dd0eeeeee0ddee0ddcddcdddd0eee0dccdeee0dd0cddeee000cd
0dddc0dccc0eeeeedcc0eeeeeeeee0cddccdd0eee000e0cddccdd0eeeeee0ddd0eeeeeeedd00000eeeee0cddeee0000000000eeeee0dcd0e0dddcccdeeeee0cc
0d0ddc00cd0eeeeeccd0eeeeeeeee0cc00dddd0eeeeee0cc00dddd0eeeeee0dd0eeeeeeedccdddd0eeee0cc0eeeeeeeeeeeeeeeeee0dd00e0d0ddc00eeeee0cc
0000000dddd0eeeedddd0eeeeeeee0cd0e00000eeeeee0cd0e00000eeeeee0dd0eeeeeee0cddddd0eeee0cd0eeeeeeeeeeeeeeeee0dcd0ee000000e0eeeee0cd
eeeeee000000eeee00000eeeeeeee0ddd0eeeeeeeeeee0ddd0eeeeeeeeeeee00eeeeeeeee0000000eeee0dd0eeeeeeeeeeeeeeeee0dccd0eeeeeeee0eeeee0dd
eeeeeee000eeeeeeeeeeee000eeeeeeeeeeeeee0000eeeeeeeeeee0dd0eeeeeeeeee00dd0e000eeeeeeeeeeeeeeeeeeeee0000eeeee0cc00eeeeee000eeeeeee
eeeee00ccc0eeeeeeeeee0ccc00eeeeeeeeeee0cccc0eeeeeeeeee0dd0eeeeeeeeee0dd0eeeeeeeee000eeeeeeeeeeeee0f77f0eee000ccceeee00ccc00eeeee
eeee0dddd000eeeeeeee0cc0ddd0eeeeeeeee0c0dddc0eeeeeeeeee00eeeeeeeeeee000eeeeeeeee0ddd00eefffeffeee0ffff0ee0d0d0cceee0dd000dd0eeee
eeee0ddddccd0eeeeee00ccdddd0eeeeeeee0cdddddc0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedcccdc0e111e11eeee0000eee0dd00ddeee0ddcccdd0eeee
eee0cd771d170eeeeee0ddddd0cc0eeeeeee0dccd771d0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedf0f0d0eeeeeeeeeeeeeeeeee0dd0ccdee0d771d177d0eee
eee0cd771f170eeeeee0ddddd0cc0eeeeeee0dccd771f0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0ddd00eeee11eeeeeeeeeeeeee00ddc0ee0d771f177d0eee
eee0cdffffff0eeeeee0ddddd0cc0eeeeeee0dccdffff0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eeeeeeeeeeeeeeeeeeeee0dddd0eee0dfffffffd0eee
eeee0ddffff0eeeeeeee0dddddd00eeeeeeee0ddddff0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000eeee0dfffffd0eeee
eee0cc0000c0eeee00c0eeeeeee0cc00000eeeeeeee00cc0000ccdeeeee0deee00ccdeeeeeeeeeee00ccdeeeeee0cc0000c000eeeeeeeeee0000dd0e00ccdeee
ee0dcccccc0c0eeecc0c0eeeee0dcccccc00eeeee00dcccccccccdee000cdeeeccccdeeeeeee0c00ccccdeeeee0dcccccc0d0d0eeeeeeeeeccc0dd0eccccdeee
e0ddd0cccc0dd0eecc0dd0eeee0dd0cccc00eeee0ddddc0cccc000eec0000eeecc000eeeee0000cccc000eeee0ddd0cccc00dd0eeeeeeeeec0ccdd0ec0000eee
e0ddd0dddd0dd0eedd0dd0eeee0ddd0dd0d0eeee0dddd0dddd00eeeedc0eeeeed00eeeeee0dd0cd0ddcc0eeee0ddd0ddddc0dd0ee0cc0000dd0dd0eedd00eeee
e0dd0ccddcc0d0eedc0dd0eeee00dd0c0c0eeeeee00d0ccddcc0eeee0cc0eeee0c0eeeee0dddcccddccdd0eee0dd0ccddcc000eee0ddccccd0c00eeed0cc0eee
ee00ddc00ccd0eeeccc00eeeeee000dd000eeeeeee00ddc00ccd0eeeccd0eeee000eeeee0d0ddc0000dddd0eee00ddc00cdd0eeee0ddd0cd0ddc0eee0ddc0eee
ee0dddd00dddd0eedddd0eeeeeee0dddd0eeeeeeee0dddd00dddd0eedddd0eeed0eeeeee000000e00e00000ee0dddd0e0dddd0ee0ddd00000dd00eee0dd00eee
ee000000000000ee00000eeeeeeee00000eeeeeeee000000000000ee00000eee00eeeeeeeeeeeee0d0eeeeeee000000e000000ee0000eeeee0dd0eeee0dd0eee
eeeeeee000eeeeeeeeeee000000eeeeeeeeeeee0000eeeeeeeeeeeeeddddddddeee777fffff077eeeee777fffff077eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeee00ccc0eeeeeeeee0cccddc0eeeeeeeeee0dccc0eeeeeeeeeeeedddddddde777777ffffff77ee77777700fff077eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeee0ddddcc0eeeeeee0ccccc55c0eeeeeeee0dddddc0eeeeeeeeeeeddddddddee7700700fff07eeee77007000f007eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeee0ddddccd0eeeee00dddddddd00eeeeee0dddddddc0eeeeeeeeeedddddddd7770f07000f007777770f07f00f00777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ee00dd77ddd70eeee0cccd1171710d0eeeee0dddd77dd0eeeeeeeeeedddddddde770fffffffff07ee770fffffffff07eeee777fffff077eeeeeeeeeeeeeeeeee
ee0ccd771f170eeeee0ccd11717100eeeeee0dccd771f0eeeeeeeeeedddddddd777700fff0f00077777700fff0f00077ee77777fffff777eeeeee77eeee77eee
eee0cddfffff0eeeeee0cd5555550eeeeeee0dccddfff0eeeeeeeeeedddddddde77770ff0777077ee77770ff0777077ee777007ff0f0f7eeeee7e777ffff777e
eeee0ddf77f0eeeeeeee0dd55550eeeeeeeee0ddddf70eeeeeeeeeeeddddddddee77000f070007eeee77000f070007eeee70f07000f00777eee777777ffff77e
eeeeeee0000eeeeeeeeeeee00000eeeeeeeeeeee0000eeee777777c0777777c0eee07770f0ff0eeeeee07770f0ff0eeee770fffffffff07eee7707777ffff777
eeeee00ccc0eeeeeeeeee00cccc0eeeeeeeeee00ccc0eeee700000d07fffffd0ee07777700000eeeee07777700000eeee70700fff0f00077ee0070007fffff7e
eeee0ddddd00eeeeeeee0ddcccd0eeeeeeeee0ccddd00eee70dd00d07f77ffd0ee07700770070eeeee07700770070eeee07000ff0777077ee07700f07fffff77
eee0dddddddd0eeeee000ddcccdd0eee0eee0cddddddd0ee70d000d07f7fffd0ee077700770770eeee077700770770ee0770770f070007ee0770770ffff0f077
0e0dcd711d170eeeee0cdd77ccc70eeed0e0cdccd711d0ee700000d07fffffd0eee00077770770eeeee00077770770ee07707770f0ff0eee0770770ff000f07e
d0ddcd711d170eeeee0ccd771c170eeedd0dddccd711d0ee700000d07fffffd0eee07777700770eeeee07777700770ee07770777000070ee07707770ff77f7ee
0dd0cddddfdd0eeeeee0cdffcfff0eee00dd0dccddddf0eecdddddd0cdddddd0eeee000000000eeeeeee000000000eee07777077ff00ff0e077707770007700e
00000ddff1f0eeeeeeee0ddffff0eeeee00000ddddff0eee0000000000000000eee0fff0e0fff0eeeee0fff0e0fff0eef0777700fff00ff0f0777007fff00ff0
06677066777650000000149ffff9900000002eee4440000000005776665f500000000dc77cd00000ddddddddddddddddddcdcdcdcdddccddee7e77eeeee7e7ee
0006506666677765001dd499999900000004eeee44400000000f77666577ff00000ddd0cc0dd1000dcdd7cdddddc77cdddcdcdcdcddcddcdee7777fffff0777e
024006666666667701dcd99999941000002ee411331100007577766657777ff000dccdd00dddd100ddddc7c77dd77711ddccddcdcddcddcde77777700fff077e
04440666666666660dcdd9999990110000e41333333110007f77f66657777ff50dccdddccdddd110dddd77c711c77c1ddcdcddcdcddcddcd0077007000f0070e
2440666666666666dddd49999941110002413333333311006777666577777fff0dcddd7cccddd110777711dddd7771dddcddcdcdcccdccdd0f00f07f00f000f0
44405556666666664ddd99999901111004133333333316107775556577777fff1dddddc77cdd1110c7771c771c77c1ddddddddddddddddddfff0fffffffff0ff
44406755555666669ddd999999ff99144233336763330561667555507777ffffc1dddd0cc0d1110cd7771777777711dddcddcddccddcddcdff0700fff0f0000f
254400067755555594dd9999999994141333365006330071666655507777ff5571de76d00d67e107dc7777777771d11ddcdccdcddcdccdcd007770ff07770070
775427700077777599dd4449999991143e43370007330061606666666665555571d7750dd0577107dd7777c777c1d11dcdcdcdcddcdccddce077770f07000770
6764277076000566994d77044999411472e43600563f3611600766666665577fc1d7700ee007710cddc77717771dd11dcdcdcdccccdcdcdcee07770ff000070e
66642e7777507000494d770049906112e844336763ffe1116007007000657777d1d7750ff057710ddd1d11177c1dd11dcdddcdcddcdcddcce0707770ffff00ee
565442e77ee77220091de70709077140e84433333ff00e10060000700065f777d1de77f0ff77e10dddd1ddd771dd11ddcdddcdcddcdcdddce007777770007700
054442eeff4fe20001ddde779f77e1001442331eff000e10065500000065fff700dffffeffeee100ddd11dd711d111dddddddddddddddddd0ff07777770770ff
504442e00ffff200441ddeeff4fe10004001131fff00e1045065555550655fff000dffff00fe1000dddd11dd11111dddcccccccccccccccc0fff077777070fff
650442e770ff20059940dde0fff10000ee400131ffee104e6506555550655005cd10dff0ffe101dcdcdddd11111dddcddcccccccccccdddde0ff000770070ff0
6665420effe20056999401de0e100000eeee400000004eee6650055506550677cccd005fe500dcccdddddddddddddddddddccccdddddddddee000ee00ee0e00e
777777777777777a000000000000000020000000000202000002020078777787000000000000000000000001011111101110111144440000000000007777777a
7aaaaaaaaaaaaaa900aaa000000000002000000002222200000202008b8888b8666666666666666111111111001111000000000044400004555555557aaaaaa9
7a99999a99999aa90a09090020000000200000002200000222220222000bb00065555555555555510001000001111110111111104400004466666666799999a9
7aa999aa90bb07a90a90a909200222222002222202000200000200000008800065677777777776510001000001111010111111104000044477777777790bb079
7aaa9aaa900007a90a0a090020000000200000002200020222222222787777876566666666666651000100000111101011111110000044446666666679000079
7aaaaaaa908807a900999000000000002000000002022200000000008b8888b86555555555555551111111110011010000000000000444405555555579088079
7a999999900007a90000000000000000200000000000000000020200000bb0006570000000000651000000011111111111101111004444001111111179000079
7a90000000cc07a9009a9000000000002000000000020200000202000008800065750565500506510000000111111111111011110444400000000000790cc079
7a900000c00007a9009a900000000000d000000000000000aaaaaaaa7877778765700000000006510001000109994094000000005ffff5510677765079000079
7a90c0c0c0cc07a9009a900000000000d0000000cdccddcd999999998b8888b86570000000000651110101110444404406006006f555555105676510790cc079
7a900c0c000007a9009a9000d0000000d0000000d0dd00d000000000000bb0006575056550050651000500000000000000756570555555500567651079000079
7a90000c00cc07a9909a9000d00dddddd00ddddd00000000808080800008800065700000000006510024200050555505005776100000000001151100790cc079
7a900000000007a9009a9000d0000000d0000000000000008080808078777787657000000000065100b940000000000006677666f5515fff0567651079000079
7aa77777777777a9009a900000000000d000000000000000000000008b8888b865555555555555511249421194090499005665105551f555056765107a777779
7aaaaaaaaaaaaaa9009a900000000000d000000000000000aaaaaaaa000bb000655555555555555100242001440404440071617055505555056765107aaaaaa9
a999999999999999009a900000000000d000000000000000999999990008800000000000000000000000000100000000060060060000000005676510a9999999
dddddddd000001d1000111102222222299999999999999983111333333333333001ddddddd111000677777770000000077777776656666560567651005676550
dddddddd1000001001566551ee222222980000000000008a11611111113333336777777777776650d66777760076776776601665515555150567651005676655
dddddddd1000100115665515eee22222980000000000008a161733333113333356767777667655107dd6666d0777777765555555000110000567651005677666
dd1ddddd0011d10001555151eee22222984000000000048a11711611131133335676777766765510777dddd7077777c751111111000550000567651005667777
ddd1111d01dd110000115110eeee22ee980000000000008a31116173113133331151555511511000677777760d777c6677777776656666560567651005566666
11dd111101d1100055101105eeeeeeee980000000000008a33311711313133335676777766765510d677776d05c7665576601665515555150567651000555555
111111110110001065510056eeeeeeee8aaaaaaaaaaaaaaa333311113131333356767777667655107d6666d70567655165555555000110000567651000011111
d111111d0011011151510056eeeeeeeea111111111111111333333313131333356c677776676551077dddd770567651051111111000550000567651000000000
d8dddfddfb8b88bf511005652222222288a888a81110111033333311717113335dcd777766765510000000000000000099999990656666560000000055676510
d8dddfdd2fbbfbf2105501552222222e8aaa88a83b313b3111111110000011111dcdc7ccd6cd1510776777677767700090000020515555150e00e00e56676510
dbddd2dd82ff2f2805565011222222eeaa8a88aabbb1bbb1333333700000633356767777667655107777777777777700900000900001100000e0e0e066776510
dbddd2ddb822828b01551500eee22eee8aaa8888bbb1bbb1111111100000111156767777667655107777c777777777d0900222900005500000000e0077766510
dfddd8ddfb88b8bf00115510eeee2eee88a88888bbb1bbb133333370000063331151555511511000c77c67cc7c777d1090022290656666560ee00eee66665510
dfddd8dd2fbfbbf255101105eeeeeeee88aaaaa8bbb1bbb1111111100000111156767777667655105d755d555c67c5109002229051555515000eee0055555110
d2dddbdd82f2ff2865510056eeeeeeee888888a83b313b3133333311616113335676777766765510111111115567c510929999900001100000e0e0e011111100
d2dddbddb828228b51510056eeeeeeee888888a81110111033333331111133331151555511511000000000000567651000000000000550000e00e00e00000000
__label__
000000000hhhhhhhh000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000hhhhh000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000hh0000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
0000000000000000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
0000000000000000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
00000000000000000000000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
00000000000000000000000hhhhhhhhsssssshhhssssssshssssshhssssshhhhhhhsssshhhhhhhsssshhssssshhhhhssssshhhhhssshhsssshhhhhhhhhhhhhhh
000000000000000000000000hhhhhhhssssss0ssssssss00sssss0hsssss0hhhhsssssssshhhhhssss0ssssss0hhhssssss0hhhhsss0hssss0hhhhhhhhhhhhhh
000000000000000000000000hhhhhhssssss0sssssss000sssss00sssss00hhhsssssssssshhhssssssssssss0hhhssssss0hhhssssshsss00hhhhhhhhhhhhhh
000000000000000000000000hhhhhhssssssssssss000hhsssss0hsssss0hhhsssssssssss0hhsssssssssss00hhsssssss0hhhsssssssss0hhhhhhhhhhhhhhh
000000000000000000000oooooooossssssssssss00ooosssss00sssss00ooosssss0ssssssossssssssssss0ooosss0sss0ooosssssssss0oooohhhhhhhhhhh
0000000000000000000000ooooooocccccccccc000ooooccccc0occccc0oooccccc00cccccc0cccccccccccc0ooccc00ccccooccccccccc00hhhhhhhhhhhhhhh
00000000000000000000000ooooosssssssss000ooooosssss00sssss00ooosssss0osssss0ssss0sss0ssss0ossssssssss0osssssssss0hhhhhhhhhhhhhhhh
000000000000000000000000oooocccccccc00oooooooccccc0occccc0ooocccccc0occccc0cccc0oc00cccc0o77777777770h7770777770hhhhhhhhhhhhhhhh
000000000000000000000000hooocccccccc0oooooooccccc00ccccc00ooocccccc0ccccc0777700oo0777700ccccccccccc0cccc0hccc00hhhhhhhhhhhhhhhh
000000000000000000000000hhoccccccccccoooooooccccc0o777770ooooo777777777770cccc0oooocccc0o77770hh7777077770h7770hhhhhhhhhhhhhhhhh
000000000000000000000000hhh77777777777ooooo7777700cccccccccccccccccccccc0777700oooo77770777700hhh0000h0000hh000hhhhhhhhhhhhhhhhh
000000000000000000000000hhcccccc0ccccccooooccccc0o7777777777770777777770077770hhhhhh0000h0000hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000hh7777770o777777oo777770077777777777700o07777000oo0000hhhhhhhhhhhhhhh70hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000h77777700oo777777o777770oo000000000000oooo0000ffhhhhhhhhhhhhhhhhhhhh7070hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000h7777770oooo000000o00000777770ooooooooooh77770fh777770hh770hhhhh70hh0700h777770hh70hh70hhhhhhhhhhhhhhhhh
000000000000000000000000hh000000oooooooooooooooo700070o707070hhhh70070hh000070hh000h70hh7777000hh000070hh70hh70hhhhhhhhhhhhhhhhh
000000000000000000000000hhhhhhhhhooooooooooooooo70oo70h000070hhh700h70hhh70700hhhhhh70hh70000hhhhhhhh70hh70hh70hhhhhhhhhhhhhhhhh
000000000000000000000000hhhhhhhhhhoooooooooooooo70hh70hhhh700hhh00h700hhh0700hhhhhh700hh70hhhhhhhhhhh70hh00hh00hhhhhhhhhhhhhhhhh
000000000000000000000000hhhhhhhhhhhooooooooohhhh777770hh7700hhhhhh700hhhhh070hhh77700hhh07770hhhh777770hh70hh70hhhhhhhhhhhhhhhhh
000000000000000000000000hhhhhhhhhhhhooohhhhhhhhh000000hh000hhhhhhh00hhhhhhh00hhh0000hhhhh0000hhhh000000hh00hh00hhhhhhhhhhhhhhhhh
0000000000000000000000000hhhffhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhffhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000000hhhhhhffffhhhhhhhhhhhhhhhhhhhhhhhhhhhh7hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000hh00hhhhhhhhhhhhfhffhhhhhhhhhhhhhhhhhhhh77hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
000000000000000000000000hhh0hhhhhhhhhhhhhhhhfffffffhhhhhhhhhhhh77hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjhhhhhhhhhhhhhh
000000000000000000000000hhh0hhhhhhhhhhhhhhhhhhhhhhffff7fhhhhhh77hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh4vv4hhh0jhhhhhhhhhhhhhh
000000000000000000000000hhh0hhhh000hhhhhhhhhh00hhhhhhhhhf7777777hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhj4vj04h0jjjhhhhhhhhhhhhh
000000000000000000000000hhh0hhh0000000hhhhhhh0000hhhhhhhhhhh07777777fhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjjj00jjjjjhhhhhhhhhhhh
000000000000000000000000hhh00h00000000000hhhhh000hhhhhhhhhh007000shhhf7ffffhhhhhhhhhhhhhhhhhhhhhhhhhhhh76j67jv00jjhhhhhhhhhhhhhh
000000000000000000000000hhhh0000000000000000hh00hhhhhhhhh00077sssssshhhhhhfffffffhhhhhhhhhhhhhhhhhhj0jv60j06j404vvjj0hhhhhhhhhhh
00000000000000000000000000hhh0000000000000000h00hhhhhhhh00077ssssscsshhhhhhhhhhhhffhfhhhhhhhhhhhhhjjj0vjvfvj004vvvjjjjhhhhhhhhhh
0000000000000000000000000000h0000000000000000h00h00hhhh00007sssssssssshhhhhhhhhhhhhhhhhhffffhhhhhhjjj0hh40fv0v44hh0jjjhhhhhhhhhh
000000000000000000000000000000000000000000000h00h0000hh000ffsssssssssshhhhhhhhhhhhhhhhhhhhhhhhhffhhjjhhhhjjjvv40hhhjjhhhhhhhhhhh
000000000000000000000000000000000000000000000h00hh000hh00f70sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhvvv004hhhhhhhhhhhhhhh
000000000000000000000000000000000000000000000h00hh00hhh0ff00sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjvjjjjv40hhhhhhhhhhhhhh
000000000000000000000000000000000000000000000h00hh00hhh0ff00sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhjjjjj4hhhvjjj00hhhhhhhhhhh
000000000000000000000000000000000000000000000000hh00hhhff000sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh00jj0hhhhhjjjjiillhhhhhhhh
00000000000000000000000000000000sssss000000000000000hhhf0000sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh000hhhhhhhhjiillllllhhhhh
00000000000000000000000000000099ff9sss000000000000000hf00000sssssssssshhhhhhhhhhhhhhhhhhhhhhhhhlllliihhh00hhhhhhhhhiillllllihhhh
0000v00000000000000000000000009999ssscs00000000000000ff00000sssssssssshhhhhhhhhhhhhhhhhhhhhhhhlllllliiiiscccccccccsiilllllliihhh
000f75000lllii00000000000009049990sssss90000000000000fh00000sssssssssshhhhhhhhhhhhhhhhhhhhhhhllllllliiiiccccccccccciillllllliill
00o777s00llllii000000000000909999ffsss99000000000000fhh00000sssssssssshhhhhhhhhhhhhhhhhhhhhhhlllllllliiisccsccccscsilllllllliill
00097r000lllliiii000000000040999994ss494000000000000fhhh00000sssssssshhhhhh00cccchhhhhhhhlllilllllllliiisscsscscscsilllllllliiil
0000f0000llllliiii0000lllll40649946ss99400000000000f0hhh00000sssssssshh0000ssshscc7hhhhhllllilllllllliiissssscssscsilllllllliiil
000000000lllllliiiiillllllli0709470ss9099ss0000000000hhh00000ssssssss00000ssssshscc7hhhlllllilllllllliiicsscsssssssillllllllliil
007777700lllllliiillllllll00047477vss099ssv4s00000f00hhhh0000sssssss00000ssssssshccc7hllllllilllllllliiiccscsssssssillllllllliii
007070700llilllliillllllll0000vff0vs0490sssfss0000000hhhh00000ssssss0000ssssssss0scc7hllllllilllllllliisccsccscscssillllllllllii
007070700llliilliillllllll00000v0vs09940sss4vs0000000hhhhh0000sssss00000sssssssss00scsllllllilllllllliissccccscccssillllllllllii
007777700lllliiiiilllllllll000illl499990sssss0s000000hhhhhh0000sss00000ssssssssssss00sslllllilllllllliisscccccccccsillllllllllii
000077700llllliiiiilllllllllliiilll4ss990sssss0iilllllllhhhssscccc00000ssssssshccsssscslllllilllllllliisscscccccscsiilllllllllii
000000000lllllliiiillllllllliiiil49999ss0s0so0siilllllllllhssscccc00000sssssshsccccsssssllllilllllllliisssscscccscsiilllllllllii
000070000lllllliiiiilllllllliiii0s999999900s00sillllllllllhssscccc00000sssssshscccc7ssssllllilllllllliisssscsscssssiilllllllllii
000070000llllllliiiilllllllliii0sss949994400ssiilllllllllllssscccc000000sssss0ssccc7ssssllllilllllllliissssssssssssiilllllllllii
000000000llllllliiiillllllll000sssslll4440000iillllllllllllsssccccs000i4vvvsss00ssc7ssssllliilllllllliisscsscssscssiilllllllllli
007777000llllllliiiiillllll0sss0ssslllll000000illllllllllllsssccccsc0iv6006vssss007sssssllliilllllllliiscccsccsccssiilllllllllli
007777700lllllllliiiiilllll00ssssssllllll00000illlllllllllllssccccoc04f70076hsssssssssssllliilllllllliisccccccccccsiilllllllllli
007000700lllllllliiiillllll0000sssllllllll0000illlllllllllllssccccos0v7700776sssssssssssllliilllllllliisccccscccscsiilllllllllli
007777700ll40404liiillllllll00000slllllllll00iilllllllllllllssccccos0v77ss776hssslv0ssssllliilllllllliisscscscscscsiiillllllllli
000777700l40404404iillllllllliiiiilllllllllliiilllllllllllllsscccccs044766776hss06fv0sssllliilllllllliisscssssscsssiiillllllllli
000000000l40404044065lllllllliiiilllllllllliiiilllllllllllllsscccccs0vv47777vhs007fv0sslllliilllllllliisssssssssscsiiillllllllll
007000700l004040406665666lllliiiilllllllllliiiilllllllllllllssccccc00vvvvffffv40s7f40sslllliilllllllliiscscscsssscsiiillllllllli
007000700l00000005665677766lliiillllllllllliiiilllllllllllllssscccc00vvvffffff7s67flssllllliilllllllliiscccscscsccsiiillllllliii
007777700ll0004440055666677766iillllllllllliiiillllllllllllisssccccs04vvffffv4f67f40s7lllliiilllllllliisccccccccccsiiilllliiiiii
000777700ll0000000055666666677766lllllllllliiilllllllllllllisssccccc0ivvffffffffvv0s7clllliiillllllliiiscscccccccssiiillllliiiii
000000000lll000000456666666666677766lllllliiiilllllllllllliiisscccccs04vf4iffffffvsccllllliiillllllliiissscscscscssiiilllllliiil
007000700lll0066044i66666666666666776llllliiiillllllllllliiiissccccccshvffvlfffffsccllllliiillllllliiiissssssscssssiiilllllliiil
007777700lll00067444ii56666666666666llllliiiiillllllllllliiiisscccccccssv4fffffvslllllllliiillllllliiiissssssssssssiiilllllliill
007777700lll5005654066ii5566666666llllllliiiiillllllllllliiiisscccccccsssvvvfvscllllllliiiillllllliiiiisscscscsscssiiillllllilll
007000700lll556555407706iiii555lllllllllliiiilllllllllllliiiissscccccccssssssccccllllliiiiillllllliiiiisccscccscccsiiillllllllll
000000000lll5566004067776706i0llllllllllliiiillllllllllliiiiisssccccccccssssccccccllliiiilllllllliiiiiisccccccccccsiiillllllllll
007770000lll55660044077vv77700llllllllllliiiillllllllllliiiiissscccccccccccccccccclliiilllllllllliiiiiiscsccsccccssiiillllllllll
007770000lll556660440vvf4ffl0illlll044llliiiilllllllllliiiiiissscccccccccccccccccclissslssslllllliiiiiissscssccscssiiillllllllll
007070000lll5566565407lfffv0440lll0444llliiillllllllllliiiiiissscccccccccccccccscclsssshsscsllllliiiiiissssssscssssiiillllllllll
007777700llll55656650v70ff004440440440lliiiillllllllllliiiiiiissscccccccccccccscclhsssshsssssllliiiiiiisssscsssssssiiillllllllll
000777700lllllii566665vfv560044444440llliiiillllllllllliiiiiiissscccccccccccccscss0shssh0000sllliiiiiiiscsccscscscsiiilillllllll
000000000lllllii566666666660004444400llliliillllllllllliiiiiiisssccccccccccccscsss0shsshssss0llliiiiiiisccccscscccsiiilillllllll
000000000lllliii5566666666500044440444lliliillllllllllliiiiii0sssccccccccccccsssss0shsshssss0lliiiiiiiisccccccccscsiiiiillllllll
000000000lllliii056666660lii0004440444liiliillllllllllliiiiii00ssccccccccccchsssssssshh00000sliiiiiiiiisccsccsccscsiiiiillllllll
000000000lllliii000444444lili00440400lliliii99994lllllliiiii0000hccccccccccs0sssssssss0sssss0liiiiiiiiisssscsscssssiiiiiilllllll
000000000lllliii004444444iilii0400440liilii9779994lllliiiiii0000sssccccccsss00ssssssss0sssss0iiiiiiiiiisssssssss66666666666666ll
000000000llliii55044444666iliii044044liiiijj9jj9944llliiiiii000sssssssssssss000sss0ssss00000siiiiiiiiiiscscss6666666666666666666
000000000llii55560444466666llii44ll44liiii999jj9jj0llliiiii0000sssssssssssssl000000sss0sssss0iiiiiiiiiisccc666666666666666666666
000000000lii5556660440566666liiiilllliiii9477999944lliiiiii000sssssssssssssil0000000ss0s000s0iiiiiiiiiisc66666665555555555555666
000000000iii555666iiii55665444iiiiiiiiiiii57s777444iiiiiiii000sssssssssssssiii0000000ss000000iiiiiiiiiis66666555f77777777ffff556
000000000iii055564iiiii55504444iiiiiiiiii79676s75044iiiiiiics0sssssssssssssiiii0000000000000iiiiiiiiiii666655f777777777777fffff5
000000000lli0044444lllll50044444iillllll9999557654illlllllsscchssssssssssssllllllill000000llllllliilll66665f777777777777777fffff
000000000ii000444440iiii00044444iiiiiii04449505597iiiiiiissssscsssssssssscciiiiiiiiiiiiiiiiiiiiiiiiii6666577777777777777777fffff
00000000000000044444llll00444444llllll0004440009999lllllssscccscsssssssccssslllllllilllllllllllllllli66657777777777777777777ffff
00000000000004444444llll00444444lllllll000000009944llllssscccccscssssscsscccclllllllilllllllllllllll6665f7777777777777777777ffff
00000000000044444444iiii00444444iiiiiiiiiiii000440iiiiisssccccccssssshsccccccciiiiiiiiiiiiiiiiiiiiii666577777777777777777777ffff
00000000000444444440000l00444444llllllllllllilllllllllsssccccccccllllssccccccccllllllllillllllllll56665f77777777777777777777ffff
00000000000444444400000000444444lllllllllllilllllllllssscccccccclllllsssccccccccllllllllillllllll556665777777777777777777777ffff
00000000000044440000000000044444llllllllllilllllllllssscccccccclllllllsssccccccccllllllllilllllll555665777777777777777777777ffff
000000000000000000000000000044400llllllllillllllll000hcccccccclllllllllsssccccccccllllllllillllll555550777777777777777777777ffff
000000000iiiii00000000000004444444iiiiiiiiiiiiii0000ssscccccciiiiiiiiiiisssscccccshsiiiiiiiiiiiii555500777777777777777777777ffff
000000000liilll000000000004444444444llilllllll0000sssssscccclllllllllllllssssccss0ssslllllllillll55550077777777777777777777fffff
000000000illllllll0000000044444444444illllll00000ssssssscccllllllllllllllisssssc0ssssslllllllillll5550077777777777777777777fffff
000000000lllllllllll000000044444444444lllll00000ssssssscscllllllllllllllllisscc00ssscsslllllllilll055007777777777777777777ffffff
000000000lllllllllllll0000004444444444llll00000sssssssssslllllllllllllllllill000sssssssllllllllill60000f7777777777777777ffffffff
000000000lllllllllllllll0000000444444llll00000sssssssssssllllllllllllllllllil000ssssssssllllllllil6666666ff77777777777ffffffffff
000000000lllllllllllllllll0000000000llll00000sssssssssssslllllllllllllllllli0000ssssssssllllllllli666666666666666655555555555555
000000000lllllllllllllllllllllllillllll00000ssssssssssssslllllllllllllllllll0000ssssssssslllllllll666666666666666665555555555555
000000000iiiiiiiiiiiiiiiiiiiiiiiiiiiii00000sssssssssssssiiiiiiiiiiiiiiiiiiii0000sssssssssiiiiiiiii566666666666666665555555555555
000000000llllllllllllllllllllillllll000000ssssssssssssssllllllllllllllllllll0000sssssssssslllllllll05566666666666665555555555555
000000000lllllllllllllllllllillllll000000sssssssssssssslllllllllllllllllllll0000sssssssssslllllllll007700000666666f7777fff555555
000000000llllllllllllllllllilllll00000000sssssssssssssslllllllllllllllllllll0000sssssssssslllllllll0077000006666f77777777fff5555
000000000lllllllllllllllllilllll00000000ssssssssssssssllllllllllllllllllllll0000sssssssssslllllllll007700000666f7777777777fff555
000000000llllllllllllllllilllll000000000ssssssssssssssllllllllllllllllllllll0000sssssssssssllllllll00770000066677777777777fff555
000000000lllllllllllllllillll00000000000ssssssssssssslllllllllllllllllllllll0000sssssssssssslllllll00770000066f777777777777fff55
000000000llllllllllllllillll0000000000000sssssssssssllllllllllllllllllllllll0000ssssssssssshhslllll00000000066777777777777ffff55
000000000lllllllllll00000000000000ssssss00hhssssssss0000llllllllllllllll000000000ssssssss0hssssslll500000000667777777777ffffff55
000000000llllll0000000000000000ssssssssssssshhsssss000000000000000000000000000000ssssss00sssscssssl5555000006677777777ffffffff55
000000000lll00000000000000000ssssssssssssscssshsss00000000000000000000000000000000sssssssssssssssss05555555566f777777fffffffff55
000000000ll00000000000000000sssssssssssssssssssss00000000000000000000000000000000sssssssssssssssssss5555555566f777777fffffffff55
000000000ll0000000000000000sssssssssssssssssssss000000000000000000000000000000000ssssssssssssssssssss5555556666f77777ffffffff555
000000000ii0000000000000000sssssssssssssssssssss0000000000000000000000000000000000ssssssssssssssssssss555556666ff7777ffffffff555
000000000ll0000000000000000ssssssssssssssssssss000000000000000000000000000000000000sssssssssssssssssss0555566666fff77fffffff5555
000000000llll000000000000000sssssssssssssssssss0000llllllllllllllll000000000000000000ssssssssssssssss00000f777777ffffffffff55555
000000000lllilll00000000000000ssssssssssssssss00lllllllllllllllllllllllllll00000000000000000000000000000ff7777777777ffffffffffff
000000000llillllllllll00000000000000000000000illlllllllllllllllllllllllllllllllllllllillllllllll0000000ff777777777777fffffffffff
000000000lillllllllllllllllllllllllllllllllllilllllllllllllllllllllllllllllllllllllllilllllllll00000000ff7777777777777ffffffffff
000000000illllllllllllllllllllllllllllllllllilllllllllllllllllllllllllllllllllllllllllillllllll0000000ffff777777777777ffffffffff

__gff__
00000c0e0000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000200000000000000000000000000000001010102777747471717e8e8b8b888888888b8b8e8e8171747477777777747472727171707070707171727273737373747474747575777777777777727275757
7777777701058102000000000000000000000000000000b800000000000000000000000000000000000000000000000000000000000000000000000000000000424242000000002a4242000000000042424242010101422242420042c2424242020142024242424242424252422a42420204420242424242424252524222c242
__map__
06070706d2072a06e2c2e285c2e006ff06e0e245e2824506fff18425a128fc0607070694082a06e0a2e265e2a2e265e2a2e265e4a22227e265a20006ff0667e2a367e2a365e2e08283e2478284c2e082e008e08206fff1812e913c6448743aa426a42cf23744fc06070706a4882a0640a2e225e2a206ff06422aa429a44006ff
f17144f275427543fc07a5892a06ed4b0006ff06c0e2cb8ce2cb8ccb8ccb8ccb8c0d06fff1834e835afc06070706ad882a06e2e000e3e006ff06e2a4e229a44006fff17457fc06070706ad862a06e2e000e3e006ff06e2e00de3e006fff1925b125b525cfc06070706af882a06e2a2e225e9a2e2080fe6a40eff06e20ac028c2
8582838285e2c28582e38382e28f82830efff5216df17158915c725ef2645365526554f4546ff70160f8a17cfc04c1071bc3ffe280e460e28060e40005e006fff1631a9110fc06c9071b09e48283e008ff07e0616263a26108fff19415fc06cb081b07e041424362412123e24243e3820103e462010208ff07a2a3c26163e061
63e02ae02ae0010203e3822123e008fff1841a811e633a9436512c61246128fc06db071b05e3824143e008ff07e06163e2644108fffc06dd071b05e02123424421010203424442212201034443e262212208ff072c6ba26be22c6b646b646b642c64e36b64e22c6de008fff1713c91467458233a234623529152fc06ed071b09
e48283e008ff07e0212364212208fff17455fc04af061b05e06163a281824143a2a3e3e021222ee6e010ff07e260e380e360e58041424ee68910fff5226df1a35ef4546ff70160f8c27cfc08c10813c3ffe7a0e360e3a0e28740fff18110a115711efc0ac909130060e24060e2e000ff01e0e200e2c0a001fff1a1184114fc0a
8c091300e020e301e821e2410121e741e36141e05700ff01e2c0e2e0e2c0e3e0e2c0e040e2e0c0e280e2004000202200e2e080e2e001fff1a11a612a621ea2248134424041424137fc0aa48713003741e201e24100ff01e282e28082b701fffc09e68713f7e000ff60a3e2a0e280e260e240e0c06460e080a280a26004008701
fff1a1488150626c915aa162914c9166fc0af6071300e3814160e000ff01e0024042808201fffc0af7861300e080c0e2a0604005e68106ff01804080e260e22005e64006fff5236df4536ff70160f8a37cfc01c0870b003fe5e000ff00e241e2a1e24100fff18403840bf69204920cc108fc0280870b009fe5c100ff00bfe5e0
00fff3c607c509a40b610b850d460d8206830845084405f60208fc02c3870b00ecc1e241e9c1e206c5e2c1c5c100ff00bfe2a1e241e3a1e4e0e221e9e0e2a1a5e261e2e000fff1b10e84099438823af24732f3740e5311921666206524332432266128662c9427c32bc12ff6c104910a0106811a011401240126012e5132a138
02380232c2300228021e421c02109208013cfc00010100db070b00e285e281e2e000ff00e2e0e261e2a500fff1b43cf6a2362138fc05de470b02ff02e2a2e262e2a2e2e0c26202e2e082e08242e2e082e082e082e242e282e2e002fff182529242826aa25ef6a236a238c132c134c13ac13ca144d24272469152b15cb258b260
b266b26891629164b250b14cb26ab26cfc00010100f6070b00e285e281e2e000ff00e2e0e261e2a500fff19166f62268a168fc00010100b7080b00e2e0e2a1a5e20703a1a5e2a1a5a104ff00c1c5e2c1c5e28183c1c5e2c1c5c104fff5246df4546ff6c162016cc1680266526ec2720276c276c27ec1780172017c0170f70160
f8c47cfcc4063aeee046474ae687494a8acae2e0c989494748ffe2e0e481e282e262e467e222294846e24748462a294748464846472a084a28e28c4648fff19444a110b11a831df4443f441f442ff8b127b237fce4073a082928e26c0608ffe0e262e26c622a22fff12348924bfc00010100e5083ae0e263e28c238c02e583e2
4203ffe222e38c22e28c8222e3aca20503fff26443675c675dfc029d083a030002eea303e5e003ff0304f4e0c103fff3965a95539450634f224932497249514726403640c54094416340423dfc00010100db083a03e64c03ff0300e602fff253365438543a533cfc00010100dd083a03e0f52303ff03f2628de36203fff1835c
f4443f444ff70130f89447fc03ef083ae303e0e4030ee6220fe803ffe303e5626ee6826fe662e003fff4535f536ff8a367fc03a7083a101500b291e751e611e651e603e003ff14e4cc71e2cce271e2cce391e2cc51cce211cc91e2cce291e2cce29103fff16466a1589152914afc03e4083ae810ff1015a0d2e39110fff2a64c
a44afc03e4083a1015e012e410ff14e012e510fffc03e4083a14e012e510ff14e013e510fffc03e4043a14e2e013e410ff1014e013e410fffc03e6083a10e2e0e50317e66218e803ff10f182e2e0e403fff5254cf4544f545ff70140f8a557fc00f7083ae20be24dec03ffe20bec825682fff5256cf4546f547ff9a07a000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000acad00acad00acad00acad00acad00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000bcbd00bcbd00bcbd00bcbd00bcbd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000096cece9600000000000096cece9600969696cecece96969696cecece9696960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000eea0a1eead00acad00aceea6a7ee00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000eeb0b1eebd00bcbd00bceeb6b7ee00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000cbcb0096cece960096cece960096cece9600878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cacacaca00acad00acadeea8a9eeacad00acad00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cacacaca00bcbd00bcbdeeb8b9eebcbd00bcbd00969696cecece96969696cecece9696960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030305050406
00000000000000000000dececececece0096cece960096cece960096cece9600979797cecece97979797cecece9797970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097000097
00000000000000000000eecccacccacc00eea4a5eead00acad00aceea2a3ee00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000eecccacccacc00eeb4b5eebd00bcbd00bceeb2b3ee00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000eecc96cc96cc0096cece9600000000000096cece9600878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097000097
e3f3e3f3e3f3e3f3e3f3eecc96cc96cc00acad00acad00acad00acad00acad00878787878787878787878787878787870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d5d5d5d5d5d5d5d5d5d5eecccacccacc00bcbd00bcbd00bcbd00bcbd00bcbd00979797cecece97979797cecece9797970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e0f1f1c2d20000eeeecfdcdccf00c0c100c700d700ed00fd00f4f400e4e5f4f4f5f5f6f7e6e7868600f2f2dcdcf200e2e2000000d5edf1ed0000eeeaeaee00deeadede00ebfafafbeffafaffe8e900dddd00c8c9dbdbddddeaebfb00ff00ef0000fafad6d600000000dcdcd6d6d0d1d0d100dcd2c2dc00d600d600cf00cece
f1f1f1f1d2c2d6d6eeeedf0000df00d0d100d700d700fd00fd00f4f400f4f4e4e5e6e7f5f5f6f7868600f2f20000f200f2f200dcdce1fdf1fde200eeeaeaee00eeeaeeee00eeeaeaee00000000f8f900dddd00d8d9dddddbdbeaeeee00000000dbdbdddd0000ebfafafbd6d6c0c1c0c1dcdc00dcc2d2dc00d6d6d600df000000
__sfx__
01010102000000c070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010202031834018450184700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105810237537075341743128b4638a4308a4008a4038a4328b461743107534375373753707534274321743107430074301743127432374333743307534075341753537537375373753727432175353753737537
011000001485014853148532085014850148532085320850168501685316853228501685016853228532285019850198531985325850198501985325853258501985019853198532585019850198532585325850
01100000191301b1301c1301e13020130201302313022130221301e1301e11020130201301e130201302213025135251302313025130251302813027130251302513023130231102513025130251322513225132
01100000141201612017120191201b1201b1201e1201e1201e12019120191101b1201b120191201b1201c12020125201201e1202012020120231202212020120201201e1201e1102012020120201222012220122
01100000191301b1301c1301e13020130201302313022130221301e1301e11020130201301e130201302213025135251302313025130251302813027130251302513023130231102513025130231302513025133
01100000141201612017120191201b1201b1201e1201e1201e12019120191101b1201b120191201b1201c12020125201201e1202012020120231202212020120201201e1201e11020120201201e1202012020123
01100000281302513027130281302c1302a1302813027130251302713027110281302811027130271102313025130251302313025130251302713027110281302813027130251302313027130281302713025130
01100000191321b1321c1321e132201321e1321c1321b132191321b1321c1321e132201321e1321c1321b132191321b1321c1321e132201321e1321c1321b132191321b1321c1321e132201321e1321c1321b132
01100000281302513027130281302c1302a130281302713025130271302711028130281102713027110231302513025130231302513025130231302311025130251302513025132251322513225132191310d131
01100000274302743025430274302741028430284102a4302a4302843028410274302741023430234302343025430254302343025430254102243023430254302543023430234102243022410234302343023430
011000001b112274222742225422274222741228422284122a4222a42228422284122742227412234222342223422254222542223422254222541222422234222542225422234222341222422224122342223422
01100000274302743025430274302741028430284102a4302a430284302841027430274102343023430234302543025430234302543025430234302341123410254302543025430254302543225432194310d431
0110000023422274222742225422274222741228422284122a4222a42228422284122742227412234222342223422254222542223422254222542223422234122341225422254222542225422254222542219421
01100000194301b4301c4301e43020430204302343022430224301e4301e41020430204301e430204302243025435254302343025430254302843027430254302543023430234102543025430254322543225432
01100000144201642017420194201b4201b4201e4201e4201e42019420194101b4201b420194201b4201c42020425204201e4202042020420234202242020420204201e4201e4102042020420204222042220422
01100000194301b4301c4301e43020430204302343022430224301e4301e41020430204301e43020430224302543525430234302543025430284302743025430254302343023410254302543025430254330d400
01100000144201642017420194201b4201b4201e4201e4201e42019420194101b4201b420194201b4201c42020425204201e4202042020420234202242020420204201e4201e4102042020420204202042300000
0110000014850148531485320850148501485320853208501685016853168532285016850168532285322850198501985319853258501985019853258532585028033250331f0331985019850198500185100000
01100400200531d0531c0531b05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100400246352063518635186353c600286002c6003c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c643286152e635286150c6430c6432e635286150c643286152e6350c643286150c6432e6350c6430c643286152e635286150c6430c6432e635286150c6430c6432e6350c643286150c6432e6352e635
0110000018633286152e6352861518633186332e6352861518633286152e6351863328615186332e6351863318633186332e635286153c610186333a61028615306352e635286353a61030610286100c61010615
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001f9301f9301f9301f9201d9301d9301d9301d920249302493024930249302493224932249222492224933249302693026930289302893029930299302b9302b9302b9302b9302b9302b9302b9302b930
010600002b4322b4322b4322b4322b4222b4222b4222b4222b4222b4222b4122b4122b4122b4122b4122b4122b4122b4122b4150040000400004000040000400244001f4001d40018400244001f4001d40000400
0106000018920189201892018920189201892018920189101d9201d9201d9201d9201d9201d9201d9201d9101d9231d9201f9201f920219202192023920239202492024920249201f9201f9201d9201d92018920
010600001842024920249201f9201f9201d9101d910189101891024910249101f9101f9151d9101d915189101891524915249001f9151f9001d9151d9001891518900009000090000000249001f9001d90018900
01060000118401184011840118400c8400c8400c8400c840118401184011840118401184011840008000080011840118401384013840158401584017840178401884018840188401884018842188421884218842
090e00003064614350153511635117351183511931100810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300003045034450304003440030400344000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700000000000000000000000000000000
050b000024445244450f20024445224450f20024430244302443024430244322443224432244250f2000f20026445264450000026445244450f20026430264302643026430264322643226432264250f2000f200
050b000027445274450f20027445000000f20000000000002a4452a4450f2002a44524400244000f2000f2002b44500000294450000027445294352a4352b4302b4302b4302b4302b4302b4322b4322b4322b415
010b0000306350c0600c0600c0600c0600c0600c0600c0600c0410c011296450c06529645296450b0600b0603e6250a0600a0600a0600a0600a0600a0600a0600a0410a011296450a075296450a0600906009060
010b00002964529645090652964509065348000f8000f8000807508060080450806008045348000f8000f800296451304013011138000f8003480029645070600706007060070600706007060070600704107011
050b00001b1451b1450f1001b1451a1450f1001b1301b1301b1301b1301b13024130221301f1301b130181301d1451d1450f1001d1451b1450f1001d1301d1301d1301d1301d13022130201301d1301a13016130
050b00001f1451f1450f1001f145001000f100001000010022145221450f1002214524100241000f1000f100231450010021145001001f1452113522135231302313023130231302313023132231322313223115
010c000027435274350000000000294352943500000000002a4352a43500000000002c4352a4352c4352e4302e4302e4302e4302e4302e4302e4302e4302e4322e4322e4322e4322e4322e4322e4322e4222e415
010c000023435234351d0001300025435254351d0000000026435264351d000000002943527435294352b4302b4302b4302b4302b4302b4302b4302b4302b4322b4322b4322b4322b4322b4322b4322b4222b415
010c000012065120651d0330000014065140651d0330000015065150651d033000001906517065190651b0401b0401b0401b0401b0401b0401b0401b0401b0421b0421b0421b0421b0421b0421b0421b02200000
010200002c4502c4502c4502c4502c45000000254502545025450254502545025450254500000000000000002c1002c4002c4002c4002c4002c4002c400251002540025400254002540025400254000000000000
0102000021360213602136021360213601c3601c3601c3601c3601c36019360193601936019360193602d3602d3602d3602d36000000000000000000000000000000000000000000000000000000000000000000
3104000030353214511c451184511645113451114510f44130343214411c441184411644113431114310f43130333214311c431184311642113421114210f42130323214211c411184111641113411114110f411
0912000021740217411e7411e71521740217401e7411e71521740217401e7411e71521740217401e7411e71521740217401e7411e71521740217401e7411e71521740217401e7411e715217001e7001e70000000
0102000026450234501f45020450274502e450344503c4503f4503c45000810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102000024610286202f630326403e5503e5503965035640326302f6202b610266102461000810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200001865024660306702b5602f5603b560345603456039562395623955139552395423954139532395313952239522395113951239515008100050000500305003c500005000050000500005000000000000
010200003c2103b6203c2403d2303c2103b6203c2403d2303c2103b6203c2403d2303c2103b6203c2403d2303c2103b6203c2403d2303c2103c2203d215008103b60000000000000000000000000000000000000
0102000014640146401464030640306402c6402c6403464034640306402c6402c640286402464020640206401c640186401464000810000000000000000000000000000000000000000000000000000000000000
010200003905039550008100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0108000031450334503545036450384503a4503c4503d45031420334203542036420384203a4203c4203d42000810000000000000000000000000000000000000000000000000000000000000000000000000000
01020000244601e4600c6601866023400254601d460194600c6601066014660186601c6602066018660146603e125008102c60030600000000000000000000000000000000000000000000000000000000000000
01020000206502c650354602b45025450204501c45019450174501445012450104500e4500d4500c4300081034600386003f5003f5003f5000000000000000000000000000000000000000000000000000000000
01020000334502f45029450314503a4503f4503f4503b450008100040000400004000040000400004000040027400234001d400254002e40036400364002f4000040000400004000040000400004000040000400
0102000024630246302063010630106303c6003c6113c61039621396203662036620336203362030620306202d6202d6202a6202a620276202762024620246202162021620008102d4000000000000324002d400
01050000174401e4411e4401844020441204401944022441224401a44023441234401b44024441244401c44025441254401d44026441264401e44027431274301f43027421274201f41027411274100081000000
01020000324502d4500000000000324502d4500081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200003136030650246501865500000000000000031360306502465018655000000000000000313603065024650186550000000000000003136030650246501865500810000000000000000000000000000000
01040000231402914523140291451b340223402f3403d5351b330223302f3303d5351b330223302f3203d5251b320223202f3203d5251b320223102f3103d5151b310223102f3103d51500810000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41414344
00 41151444
00 04160305
00 06160307
00 08160309
00 0a160309
00 0b16030c
00 0d16030e
00 0f160310
04 11171312
00 1d1f2144
04 1e204d44
00 24262844
04 25272944
04 2a2b2c44

