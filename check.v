//Check State

assign check_over = ((Matrix[0] !== Matrix[1]) && (Matrix[0] !== Matrix[4]) && (Matrix[1] !== Matrix[5]) && (Matrix[1] !== Matrix[2]) &&(Matrix[2] !== Matrix[6]) &&
	(Matrix[2] !== Matrix[3]) && (Matrix[3] !== Matrix[7]) && (Matrix[4] !== Matrix[5]) && (Matrix[4] !== Matrix[8]) && (Matrix[5] !== Matrix[9]) && 
	(Matrix[5] !== Matrix[6]) && (Matrix[6] !== Matrix[7]) && (Matrix[6] !== Matrix[10]) && (Matrix[7] !== Matrix[11]) && (Matrix[8] !== Matrix[9]) && 
	(Matrix[8] !== Matrix[12]) && (Matrix[9] !== Matrix[10]) && (Matrix[9] !== Matrix[13]) && (Matrix[10] !== Matrix[14]) && (Matrix[10] !== Matrix[11]) && 
	(Matrix[11] !== Matrix[15]) && (Matrix[12] !== Matrix[13]) && (Matrix[13] !== Matrix[14]) && (Matrix[14] !== Matrix[15])&&(Matrix[0] !== 0)&&
	(Matrix[1] !== 0)&&(Matrix[2] !== 0)&&(Matrix[3] !== 0)&&(Matrix[4] !== 0)&&(Matrix[5] !== 0)
	&&(Matrix[6] !== 0)&&(Matrix[7] !== 0)&&(Matrix[8] !== 0)&&(Matrix[9] !== 0)&&(Matrix[10] !== 0)
	&&(Matrix[11] !== 0)&&(Matrix[12] !== 0)&&(Matrix[13] !== 0)&&(Matrix[14] !== 0)&&(Matrix[15] !== 0));
	
0  1  2  3
4  5  6  7 
8  9  10 11
12 13 14 15

			256: R=((CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //2
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+14) && CounterY>=(62+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+31) && CounterX<=(positionX+35) && CounterY>=(10+positionY) && CounterY<=(59+positionY))
				   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //5
				   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+66) && CounterX<=(positionX+70) && CounterY>=(62+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+45) && CounterX<=(positionX+49) && CounterY>=(10+positionY) && CounterY<=(59+positionY))
				   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
				   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+80) && CounterX<=(positionX+84) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+101) && CounterX<=(positionX+105) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
				   );