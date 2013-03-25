/**
 *CartoonFilter Class v0.1-ActionScript3.0
 *Apr. 27, 2009
 *Bruce Jawn
 *http://bruce-lab.blogspot.com/
 *http://www.geocities.com/zhoubu1988
	  
 *Copyright (c) <2009> <Bruce Jawn>
 *This software is released under the MIT License 
 *<http://www.opensource.org/licenses/mit-license.php>
	  
 *Thanks to wsstefan, AlexPetrescu and wal5hy 
 *(http://www.kirupa.com/forum/showthread.php?p=2205469)
 **/
package test.cam{
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	public class CartoonFilter {

		public static const MGUASSIAN:BlurFilter=new BlurFilter(4,4,1);
		public static const MGX:ConvolutionFilter=new ConvolutionFilter(3,3,[-1,0,1,-2,0,2,-1,0,1],1);
		public static const MGY:ConvolutionFilter=new ConvolutionFilter(3,3,[1,2,1,0,0,0,-1,-2,-1],1);
		public static const MGXNEG:ConvolutionFilter=new ConvolutionFilter(3,3,[1,0,-1,2,0,-2,1,0,-1],1);
		public static const MGYNEG:ConvolutionFilter=new ConvolutionFilter(3,3,[-1,-2,-1,0,0,0,1,2,1],1);
		public static const MPOINT:Point=new Point();
		public static const MOTION_THRESHOLD:int=64;

		public static function Cartoonize(source:BitmapData):BitmapData {
			
			var mEdgeData:BitmapData=source.clone();
			var mRect:Rectangle=mEdgeData.rect;

			mEdgeData.applyFilter(mEdgeData,mRect,MPOINT,MGUASSIAN);
			var xData:BitmapData=new BitmapData(mRect.width,mRect.height);
			xData.applyFilter(mEdgeData,mRect,MPOINT,MGX);
			var xNegData:BitmapData=new BitmapData(mRect.width,mRect.height);
			xNegData.applyFilter(mEdgeData,mRect,MPOINT,MGXNEG);
			var yData:BitmapData=new BitmapData(mRect.width,mRect.height);
			yData.applyFilter(mEdgeData,mRect,MPOINT,MGY);
			mEdgeData.applyFilter(mEdgeData,mRect,MPOINT,MGYNEG);

			mEdgeData.draw(xData,null,null,BlendMode.ADD);
			mEdgeData.draw(xNegData,null,null,BlendMode.ADD);
			mEdgeData.draw(yData,null,null,BlendMode.ADD);

			mEdgeData.threshold(mEdgeData,mRect,MPOINT,">",MOTION_THRESHOLD<<16,0xFFFFFFFF,0x00FF0000,false);
			mEdgeData.threshold(mEdgeData,mRect,MPOINT,"<",MOTION_THRESHOLD<<16,0xFF000000,0x00FF0000,false);

			mEdgeData.applyFilter(mEdgeData,mEdgeData.rect,MPOINT,new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]));
			mEdgeData.draw(source,null,null,BlendMode.OVERLAY);//try to use BlendMode.OVERLAY

			return mEdgeData;
		}//end of function

	}//end of class
}//end of package 