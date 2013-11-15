package com.taobao.tbbpm.define.figure.line
{
	/**
	* junyu.wy
	* */
	public class Dash 
	{
		public var target:Object;
		public var _curveaccuracy:Number = 6;
			
		private var isLine:Boolean = true;
		private var overflow:Number = 0;
		private var offLength:Number = 0;
		private var onLength:Number = 0;
		private var dashLength:Number = 0;
		private var pen:Object;
	
		
		public function Dash(target:Object, onLength:Number, offLength:Number){
			this.target = target.graphics;
			this.setDash(onLength, offLength);
			this.isLine = true;
			this.overflow = 0;
			this.pen = {x:0, y:0};
		}
		
		
		public function setDash(onLength:Number, offLength:Number):void {
			this.onLength = onLength;
			this.offLength = offLength;
			this.dashLength = this.onLength + this.offLength;
		}
		
		public function getDash():Array {
			return [this.onLength, this.offLength];
		}
		
		public function moveTo(x:Number, y:Number):void {
			this.targetMoveTo(x, y);
		}
		
		public function lineTo(x:Number,y:Number):void {
			var dx:Number = x-this.pen.x,	dy:Number = y-this.pen.y;
			var a:Number = Math.atan2(dy, dx);
			var ca:Number = Math.cos(a), sa:Number = Math.sin(a);
			var segLength:Number = this.lineLength(dx, dy);
			if (this.overflow){
				if (this.overflow > segLength){
					if (this.isLine) this.targetLineTo(x, y);
					else this.targetMoveTo(x, y);
					this.overflow -= segLength;
					return;
				}
				if (this.isLine) this.targetLineTo(this.pen.x + ca*this.overflow, this.pen.y + sa*this.overflow);
				else this.targetMoveTo(this.pen.x + ca*this.overflow, this.pen.y + sa*this.overflow);
				segLength -= this.overflow;
				this.overflow = 0;
				this.isLine = !this.isLine;
				if (!segLength) return;
			}
			var fullDashCount:Number = Math.floor(segLength/this.dashLength);
			if (fullDashCount){
				var onx:Number = ca*this.onLength,	ony:Number = sa*this.onLength;
				var offx:Number = ca*this.offLength,	offy:Number = sa*this.offLength;
				for (var i:int=0; i<fullDashCount; i++){
					if (this.isLine){
						this.targetLineTo(this.pen.x+onx, this.pen.y+ony);
						this.targetMoveTo(this.pen.x+offx, this.pen.y+offy); 
					}else{
						this.targetMoveTo(this.pen.x+offx, this.pen.y+offy);
						this.targetLineTo(this.pen.x+onx, this.pen.y+ony);
					}
				}
				segLength -= this.dashLength*fullDashCount;
			}
			if (this.isLine){
				if (segLength > this.onLength){
					this.targetLineTo(this.pen.x+ca*this.onLength, this.pen.y+sa*this.onLength);
					this.targetMoveTo(x, y);
					this.overflow = this.offLength-(segLength-this.onLength);
					this.isLine = false;
				}else{
					this.targetLineTo(x, y);
					if (segLength == this.onLength){
						this.overflow = 0;
						this.isLine = !this.isLine;
					}else{
						this.overflow = this.onLength-segLength;
						this.targetMoveTo(x, y);
					}
				}
			}else{
				if (segLength > this.offLength){
					this.targetMoveTo(this.pen.x+ca*this.offLength, this.pen.y+sa*this.offLength);
					this.targetLineTo(x, y);
					this.overflow = this.onLength-(segLength-this.offLength);
					this.isLine = true;
				}else{
					this.targetMoveTo(x, y);
					if (segLength == this.offLength){
						this.overflow = 0;
						this.isLine = !this.isLine;
					}else this.overflow = this.offLength-segLength;
				}
			}
		}
		
		public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void {
			var sx:Number = this.pen.x;
			var sy:Number = this.pen.y;
			var segLength:Number = this.curveLength(sx, sy, cx, cy, x, y);
			var t:Number = 0;
			var t2:Number = 0;
			var c:Array;
			if (this.overflow){
				if (this.overflow > segLength){
					if (this.isLine) this.targetCurveTo(cx, cy, x, y);
					else this.targetMoveTo(x, y);
					this.overflow -= segLength;
					return;
				}
				t = this.overflow/segLength;
				c = this.curveSliceUpTo(sx, sy, cx, cy, x, y, t);
				if (this.isLine) this.targetCurveTo(c[2], c[3], c[4], c[5]);
				else this.targetMoveTo(c[4], c[5]);
				this.overflow = 0;
				this.isLine = !this.isLine;
				if (!segLength) return;
			}
			var remainLength:Number = segLength - segLength*t;
			var fullDashCount:Number = Math.floor(remainLength/this.dashLength);
			var ont:Number = this.onLength/segLength;
			var offt:Number = this.offLength/segLength;
			if (fullDashCount){
				for (var i:int=0; i<fullDashCount; i++){
					if (this.isLine){
						t2 = t + ont;
						c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
						this.targetCurveTo(c[2], c[3], c[4], c[5]);
						t = t2;
						t2 = t + offt;
						c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
						this.targetMoveTo(c[4], c[5]);
					}else{
						t2 = t + offt;
						c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
						this.targetMoveTo(c[4], c[5]);
						t = t2;
						t2 = t + ont;
						c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
						this.targetCurveTo(c[2], c[3], c[4], c[5]);
					}
					t = t2;
				}
			}
			remainLength = segLength - segLength*t;
			if (this.isLine){
				if (remainLength > this.onLength){
					t2 = t + ont;
					c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
					this.targetCurveTo(c[2], c[3], c[4], c[5]);
					this.targetMoveTo(x, y);
					this.overflow = this.offLength-(remainLength-this.onLength);
					this.isLine = false;
				}else{
					c = this.curveSliceFrom(sx, sy, cx, cy, x, y, t);
					this.targetCurveTo(c[2], c[3], c[4], c[5]);
					if (segLength == this.onLength){
						this.overflow = 0;
						this.isLine = !this.isLine;
					}else{
						this.overflow = this.onLength-remainLength;
						this.targetMoveTo(x, y);
					}
				}
			}else{
				if (remainLength > this.offLength){
					t2 = t + offt;
					c = this.curveSlice(sx, sy, cx, cy, x, y, t, t2);
					this.targetMoveTo(c[4], c[5]);
					c = this.curveSliceFrom(sx, sy, cx, cy, x, y, t2);
					this.targetCurveTo(c[2], c[3], c[4], c[5]);
					
					this.overflow = this.onLength-(remainLength-this.offLength);
					this.isLine = true;
				}else{
					this.targetMoveTo(x, y);
					if (remainLength == this.offLength){
						this.overflow = 0;
						this.isLine = !this.isLine;
					}else this.overflow = this.offLength-remainLength;
				}
			}
		}
		
		public function clear():void {
			this.target.clear();
		}
		public function lineStyle(thickness:Number,rgb:Number,alpha:Number):void {
			this.target.lineStyle(thickness,rgb,alpha);
		}
		public function beginFill(rgb:Number,alpha:Number):void {
			this.target.beginFill(rgb,alpha);
		}
		public function beginGradientFill(fillType:String,colors:Array,alphas:Array,ratios:Array,matrix:Object):void {
			this.target.beginGradientFill(fillType,colors,alphas,ratios,matrix);
		}
		public function endFill():void {
			this.target.endFill();
		}
		
		private function lineLength(sx:Number, sy:Number, ...args):Number {
			if(!args.length){
				return Math.sqrt(sx*sx + sy*sy);
			} else {
				var ex:Number = args[0];
				var ey:Number = args[1];
			}
			var dx:Number = ex - sx;
			var dy:Number = ey - sy;
			return Math.sqrt(dx*dx + dy*dy);
		}
		private function curveLength(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, ...args):Number {
			var total:Number = 0;
			var tx:Number = sx;
			var ty:Number = sy;
			var px:Number, py:Number, t:Number, it:Number, a:Number, b:Number, c:Number;
			var n:Number = args[0] != null ? args[0] : this._curveaccuracy;
			for (var i:Number = 1; i<=n; i++){
				t = i/n;
				it = 1-t;
				a = it*it; b = 2*t*it; c = t*t;
				px = a*sx + b*cx + c*ex;
				py = a*sy + b*cy + c*ey;
				total += this.lineLength(tx, ty, px, py);
				tx = px;
				ty = py;
			}
			return total;
		}
		private function curveSlice(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t1:Number, t2:Number):Array {
			if (t1 == 0) return this.curveSliceUpTo(sx, sy, cx, cy, ex, ey, t2);
			else if (t2 == 1) return this.curveSliceFrom(sx, sy, cx, cy, ex, ey, t1);
			var c:Array = this.curveSliceUpTo(sx, sy, cx, cy, ex, ey, t2);
			c.push(t1/t2);
			return this.curveSliceFrom.apply(this, c);
		}
		private function curveSliceUpTo(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number = 0):Array {
			if (t == 0) t = 1;
			if (t != 1) {
				var midx:Number = cx + (ex-cx)*t;
				var midy:Number = cy + (ey-cy)*t;
				cx = sx + (cx-sx)*t;
				cy = sy + (cy-sy)*t;
				ex = cx + (midx-cx)*t;
				ey = cy + (midy-cy)*t;
			}
			return [sx, sy, cx, cy, ex, ey];
		}
		private function curveSliceFrom(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number = 0):Array {
			if (t == 0) t = 1;
			if (t != 1) {
				var midx:Number = sx + (cx-sx)*t;
				var midy:Number = sy + (cy-sy)*t;
				cx = cx + (ex-cx)*t;
				cy = cy + (ey-cy)*t;
				sx = midx + (cx-midx)*t;
				sy = midy + (cy-midy)*t;
			}
			return [sx, sy, cx, cy, ex, ey];
		}
		
		private function targetMoveTo(x:Number, y:Number):void {
			this.pen = {x:x, y:y};
			this.target.moveTo(x, y);
		}
		private function targetLineTo(x:Number, y:Number):void {
			if (x == this.pen.x && y == this.pen.y) return;
			this.pen = {x:x, y:y};
			this.target.lineTo(x, y);
		}
		private function targetCurveTo(cx:Number, cy:Number, x:Number, y:Number):void {
			if (cx == x && cy == y && x == this.pen.x && y == this.pen.y) return;
			this.pen = {x:x, y:y};
			this.target.curveTo(cx, cy, x, y);
		}
	}
}
