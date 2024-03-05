<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<%=Html.Partial("CSS.Module.ARP") %>
<%=Html.Partial("GetPaymentIconStyles") %>

<style>
/* Cascading Stylesheet | Campaign Version

    @Layout

* --------------------------------------------------------------------- */
  	[style^="--aspect-ratio"] {
  		transition: background 100ms ease-in-out;
  	}
  
    [style^="--aspect-ratio"]:not([data-src-img]),
  	.load-item--success {
        background: transparent;
    }

    [style^="--aspect-ratio"]:not([data-src-img])::after {
        display: none;
    }
  
  	[data-src-img]::after {
    	z-index: 0;
      	animation-iteration-count: infinite;
  	}

	/* Canvas | @Layout */
	/* set the minimum width of our canvas */
	.dtm__in--dv .l-outer,
	.dtm__in--dv .l-header,
	.dtm__in--dv .l-footer {
		min-width: 1200px;
	}

	/* set the maximum width of our canvas */
	.dtm__in--dv .l-header__in,
  	.dtm__in--dv .l-outer__in,
	.dtm__in--dv .l-footer__in,
  	.dtm__in--dv .section {
		max-width: 1200px;
      	margin: auto;
	}

    /* fixes qa edit - Mobile: Desktop view: All section of the page are displaced */
  .dtm__in--dv .l-outer {
    overflow-x: hidden;
  }
  
  	.dtm--index #content_top {
    	max-width: none;
        padding: 0px;
  	}

    /* set the minimum height of our footer */
    .dtm__in--dv .l-footer {
        min-height: 220px;
    }

    /* set the padding of the canvas */
    .dtm__in--dv .l-outer__in {
        padding: 0.25em;
    }

    /* set the border style of our header & midline sections */
    .dtm__in--dv .l-header,
    .dtm__in--dv .o-box--banner {
        border-style: solid;
    }

    /* set the border width of our header section */
    .dtm__in--dv .l-header {
        border-width: 0 0 3px;
    }

    .dtm__in--dv .l-header__in {
        box-shadow: none;
    }

    /* set the border width of our midline section */
    .dtm__in--dv .o-box--banner {
        border-width: 3px 0;
        border-color: #2363ad;
    }


    /* Page | @Layout */
    /* set the size of our desktop video */
    .dtm__in--dv .video {
        width: 307px;
        margin: 0 auto 1rem;
    }

    /* set the size of our desktop features & benefits area */
    .dtm .fb {
        max-width: 410px;
        width: auto;
        margin: 1em auto;
    }

    .dtm__in--mv .l-nav {
        max-width: 640px;
        margin: auto;
        position: -webkit-sticky;
        position: -moz-sticky;
        position: -o-sticky;
        position: -ms-sticky;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .l-nav .l-nav__in {
      	padding: .5em 0;
        display: flex;
        flex-wrap: wrap;
        justify-content: flex-start;
        align-items: center;
        font: 1.8rem/1 'Avenir Next Bold', sans-serif;
    }

    @media all and ( max-width : 500px ) {
        .dtm__in--mv .l-nav .l-nav__in {
            font-size: 3.25vw;
        }

        .dtm__in--mv .l-nav__order {
            font-size: 4.5vw;
        }
    }

    .dtm__in--mv .l-nav .l-nav__in {
        justify-content: center;
    }

    .dtm__in--mv .l-nav__order {
        margin-left: auto;
    }   

    .l-nav a {
        display: block;
        text-decoration: none;
        padding: 1rem 1.5rem;
        transition: background 100ms ease-in-out;
    }

    .l-nav .l-nav__link:focus,
    .l-nav .l-nav__link:hover {
        background: rgba(0,0,0,0.5);
    }

    .l-nav .l-nav__link:not(:first-child) {
        border-left: 2px solid;
    }

    .l-nav__order {
        background: #ff7200;
        font: 2.4rem/1 'Avenir Next Bold', sans-serif;
        text-transform: uppercase;
    }

    .l-nav__order:focus,
    .l-nav__order:hover {
        background: #ff963f;
    }

    .wrap-text > span {
        display: block;
    }

    .dtm__in--dv .article {
        width: 63%;
    }

    .dtm__in--dv .sidebar {
        width: 37%;
    }

    .bg-offer,
    .dtm__in--mv .bg-offer {
        background: white;
    }

    @supports ( mix-blend-mode : multiply ) {
        .bg-offer {
            background: #dcf0ff;
            background: -moz-linear-gradient(top, hsla(206,100%,93%,1) 0%, hsla(180,100%,100%,1) 50%, hsla(206,100%,93%,1) 100%);
            background: -webkit-linear-gradient(top, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%,hsla(206,100%,93%,1) 100%);
            background: linear-gradient(to bottom, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%,hsla(206,100%,93%,1) 100%);
        }

        .dtm__in--dv .offer::after,
        .media__img img {
            -webkit-mix-blend-mode: multiply;
            mix-blend-mode: multiply;
        }
      
      	.media__img img {
        	will-change: opacity;
      	}
    }

    .offer,
    .offer__group {
        position: relative;
    }

    .offer__group {
        margin: 5rem 0;
    }

    .offer__group--top {
        margin: 2rem 0 5rem;
    }

    .dtm__in--dv .offer__group--top {
    	width: 415px;
    }

    .offer__order {
        position: relative;
        left: -4px;
        display: flex;
        justify-content: center;
        margin-top: -5rem;
    }
  
  	.dtm__in--dv .offer__group .btn {margin: 0 1.25rem;}

    .offer__desc {
    	font-size: 17px;
    	margin: 1rem 0;
    }
  
  	.offer__order .payment {
		width: 22em;
  	}

    .offer__product {
        position: absolute;
        bottom: 0;
        right: 0;
        pointer-events: none;
    }

    .sidebar__group {
        background: white;
        padding: 0 0 1rem;
        border: 3px solid white;
        margin: 1rem 0;
    }

    .dtm__in--dv .sidebar__group {
        max-width: 375px;
        box-shadow: 0 0 1rem rgba(0, 0, 0, 0.25);
    }

    .media,
    .media__img {
        position: relative;
    }

    .dtm__in--dv .media__img {
        /*left: 10rem;*/
    }

    .dtm__in--dv .media__content {
        position: absolute;
        top: 5rem;
        right: 0;
        width: 100%;
        max-width: 474px;
    }

    .dtm__in--mv .media__content > [style^="--aspect-ratio"] {
        max-width: 100%;
    }

    .media__playlist {
        list-style: none;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
    }

    .media__playlist li {
        flex: 1 1 auto;
        display: block;
        background: #31aeb1;
        color: white;
        font: 2.4rem/1 'DIN Condensed Bold', sans-serif;
        padding: 0.5em;
        margin: 0.2em 0.1em;
        cursor: pointer;
        transition: background 100ms ease-in-out;
    }

    .dtm__in--mv .media__playlist,
    .dtm__in--mv .media__playlist li {
        margin: 0.1em;
    }

    .dtm__in--mv .media__playlist li {
        font-size: 6vw;
        flex-basis: 45%;
    }

    @media all and ( min-width : 640px ) {
        .dtm__in--mv .media__playlist li {
            font-size: 2.4rem;
        }  
    }

    .dtm__in--dv .media__playlist li:first-child {
        margin-left: 0;
    }

    .dtm__in--dv .media__playlist li:last-child {
        margin-right: 0;
    }    

    .media__playlist li:hover,
    .media__playlist li:focus {
        background: #37f5f8;
    }

    .grid {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        text-align: center;
    }

    .dtm__in--dv .grid__card,
    .dtm__in--dv .grid__item {
        flex: 1 1 0%;   
    }

    .dtm__in--mv .grid__card,
    .dtm__in--mv .grid__item {
        flex: 0 1 319px;   
    }

    .dtm__in--mv .grid--inuse .grid__card {
        flex-basis: 200px;
    }

    .grid__card {
        margin: 1rem;
    }

    .dtm__in--dv .grid__card:first-of-type {
        margin-left: 0;
    }

    .dtm__in--dv .grid__card:last-of-type {
        margin-right: 0;
    }

    .grid__item {
        margin: 1rem 3rem;
    }

    .grid__title {
        background: #31aeb1;
        color: white;
        font: 2.4rem/1.35 'DIN Condensed Bold', sans-serif;
        padding: 0.5em;
    }
  
      .dtm__in--dv .grid__card {
        max-width: 317px;
    }

    .grid__card figcaption {
        margin: 2rem 0;
        font: 16px/1.2 'Avenir Next Medium', sans-serif;
    }

    .grid__card figcaption strong {
        font-size: 1.2em;
        text-transform: uppercase;
        display: block;
        color: #31aeb1;
        font-family: 'Avenir Next Bold', sans-serif;
    }

    .dtm__in--mv .grid__card figcaption {
        font-size: 2rem;
    }

    .dtm__in--mv .grid__title {
        font-size: 2.2rem;
        padding: 0.5em;
    }

    .dtm__in--mv .fade {
        display: flex;
        flex-wrap: wrap;
        flex-direction: column;
    }
  
    .dtm__in--mv .fade nav {
        order: 2;
    }

    .dtm__in--mv .reviews a[href*=Reviews] {
        order: 3;
    }

    .js-eflex--fade__nav {
        width: 100%;
        bottom: 0;
        top: 0;
        display: flex;
        align-items: center;
    }

    .dtm__in--mv .js-eflex--fade__nav {
        justify-content: center;
    }

    .dtm__in--dv .js-eflex--fade__nav,
    .dtm__in--dv .js-eflex--fade__nav button  {
        position: absolute;
    }

    .js-eflex--fade__nav button {
        border: none;
        background: white;
        box-shadow: 0 0 0.25em rgba(0, 0, 0, 0.25);
        padding: 0.05em;
        opacity: 0;
        font-size: 4rem;
        color: #d3d3d3;
        transition: background 100ms linear, color 100ms linear, opacity 250ms ease-in-out 1s;
    }

    .dtm__in--mv .js-eflex--fade__nav button {
        flex: 1 1 100%;
        font-size: 3rem;
        margin: 0.2em;
    }

    .dtm__in--dv .review__stars {
        max-width: 300px;
    }

    .dtm__in--mv .review__stars {
        max-width: 50%;
        margin: auto;
    }
  
  .dtm__in--dv .reviews a[href*=Reviews] {
    z-index: 10;
  }

    .js-eflex--fade__nav button[data-dir] {
        opacity: 1;
    }

    .js-eflex--fade__nav button:first-child {
        left: 0;
    }

    .js-eflex--fade__nav button:last-child {
        right: 0;
    }

    .js-eflex--fade__nav button:focus,
    .js-eflex--fade__nav button:hover {
        background: #d3d3d3;
        color: white;
    }

    .js-eflex--fade,
    .js-eflex--fade__nav {
        list-style: none;
    }

    .js-eflex--fade {
        text-align: center;
        width: 85%;
        margin: auto;
min-height: 360px;
    }

    .dtm__in--mv .js-eflex--fade {
        margin: auto auto 3rem;
    }
  
  	@media all and ( max-width : 640px ) {
      .dtm__in--mv .js-eflex--fade {
        width: 90vw;
      }
  	}
  
  	@media all and ( min-width : 641px ) {
      .dtm__in--mv .js-eflex--fade {
        width: 600px;
      }
  	}

    .js-eflex--fade li:not(:first-child) {
        opacity: 0;
        position: absolute;
    }

    .js-eflex--fade li {
        padding: 0;
    }

    .review {
        font-family: 'Avenir Next Medium', sans-serif;
        line-height: 1.45;
        color: #636363;
    }

    .review h1 {
        font-weight: normal;
      font-family: 'Avenir Next Bold', sans-serif;
        font-size: 2.4rem;
    }

    .dtm__in--mv .review h1,
    .review p,
    .review cite {
        font-size: 2rem;
    }

    .dtm__in--mv .review p,
  .dtm__in--mv .review cite {
        font-size: 1.8rem;
    }
  
  .review cite {
    font-style: italic;
    margin: 1rem 0 0;
    display: block;
}

.review cite strong {
    display: block;
}


    .hr {
       background: #b9d8f3;
       height: 4px; 
       border: none;
    }

    .grid__item [data-src-img],
    .grid__item img {
        margin: auto;
    }

    .solution {
        color: #2363ad;
        font: 2rem/1.25 'Avenir Next Medium', sans-serif;
    }

    .solution__title {
        color: #ac242e;
        font-weight: normal;
      font-family: 'Avenir Next Bold', sans-serif;
    }

    .solution span {
        display: block;
    }

    .grid__title {
        font-size: 5.5rem;
        padding: 0.1em 0.5em;
        flex: 1 1 100%;
    }

    .warn {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .dtm__in--mv .warn {
        flex-wrap: wrap;
        text-align: center;
    }

    .snippet--ft {
        border: solid #2363ad;
        border-width: 3px 0;
    }

    .snippet--ft h1 {
        color: #ff7200;
        text-transform: uppercase;
        font: 6rem/1 'DIN Condensed Bold', sans-serif;
    }

    .snippet--ft h6 {
        color: #2363ad;
        font: 2.1rem/1 'Avenir Next Medium', sans-serif;
    }


/* --------------------------------------------------------------------- *

    @Module

* --------------------------------------------------------------------- */
	/*	@Await
	 * --------------------------------------------------------------------- */
    .use-await {
		position: relative;
	}

	.use-await:before,
	.use-await:after {
		position: absolute;
		display: block;
		content: '';
		top: 0;
		bottom: 0;
		left: 0;
		right: 0;
		margin: auto;
		width: 100%;
		height: 100%;
		opacity: 0;
		background: transparent;
		transition: opacity 250ms ease-in-out 1s;
		z-index: 0;
	}

	.has-await:before,
	.has-await:after {
		opacity: 1;
	}


    /*	Order Button / @Module
    * --------------------------------------------------------------------- */
    .btn {
        display: inline-block;
        padding: .75em 1.25em;
        position: relative;
        max-width: none;
        background: none;
        border: none;
        cursor: pointer;
        font: 2.1rem/1 "niveau-grotesk", sans-serif;
        text-align: center;
        text-decoration: none;
        color: white;
        background-color: #00bccd;
    }

    .btn:hover,
    .btn:focus {
        background: #2ca0a3;
    }


/* --------------------------------------------------------------------- *

    @Theme

* --------------------------------------------------------------------- */
    /*	Font Size
        @Desc: Set up our font sizes
    * --------------------------------------------------------------------- */
    h1, .h1 {
        font-size: 60px;
    }

    h2, .h2 {
        font-size: 50px;
    }

    .dtm__in--mv h2, .dtm__in--mv .h2 {
        font-size: 4rem;
    }

    h3, .h3 {
        font-size: 44px;
    }

    h4, .h4 {
        font-size: 40px;
    }

    h5, .h5 {
        font-size: 30px;
    }

    h6, .h6  {
        font-size: 24px;
    }

    body, .p  {
        font-size: 17px;
    }

    .dtm__in--dv .c-brand--form .c-brand--form__headline {
        font-size: 2rem;
    }


    /*	@Font Family
        @Desc: Set up our font families
    * --------------------------------------------------------------------- */
    body,
    #dtm_upgrade #content_top [class*="c-brand"],
    #dtm_upgrade .dtm__in--mv, .dtm__in [class*="c-brand"],
    .dtm__in--mv {
        font-family: 'niveau-grotesk', sans-serif;
    }


    /*	@Color
        @Desc: Set up our font color palette
    * --------------------------------------------------------------------- */
    .color-primary {
        color: #2363ad;
    }

    .color-secondary {
        color: #31aeb1;
    }

    .color-tertiary {
        color: #ff7200;
    }


    /*	@Background
        @Desc: Set up our background color palette
    * --------------------------------------------------------------------- */
    .bg-primary {
        background: #31aeb1;
    }

    .bg-secondary {
        background: #2363ad;
    }

    .bg-tertiary {
        background: #ff7200;
    }

    .bg-section {
        background: #dcf0ff;
        background: -moz-linear-gradient(top, hsla(206,100%,93%,1) 0%, hsla(180,100%,100%,1) 50%);
        background: -webkit-linear-gradient(top, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%);
        background: linear-gradient(to bottom, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%);
    }

    .bg-section--mirror {
        background: #dcf0ff;
        background: -moz-linear-gradient(top, hsla(206,100%,93%,1) 0%, hsla(180,100%,100%,1) 50%, hsla(206,100%,93%,1) 100%);
        background: -webkit-linear-gradient(top, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%, hsla(206,100%,93%,1) 100%);
        background: linear-gradient(to bottom, hsla(206,100%,93%,1) 0%,hsla(180,100%,100%,1) 50%, hsla(206,100%,93%,1) 100%);
    }

    /* set the desktop color of our white-space background */
    .dtm__in--dv {
        background: white;
    }

    /* set the color of our canvas background */
    .l-outer__in {
        background: white;
    }

    /* set the desktop color of our header, midline & footer */
    .dtm__in--dv .l-header {
        background: white;
        color: #31aeb1;
        border-color: transparent;
    }

    .dtm .l-nav,
    .dtm__in--dv .l-footer {
        background: #2363ad;
        color: white;
    }
  
  .dtm__in--mv .l-nav {
    z-index: 10;
  }

    /* set the color of our form headline (defaults to #333) */
    .c-brand--form .c-brand--form__legend {
        background: #0e529e;
        text-align: center;
    }

    /* set the color of our order review table (defaults to red) */
    .dtm .c-brand--table th,
    .dtm .c-brand--table__th {
        background: #ee5a23;
    }

    /* set the color of our mobile order now button */
    .dtm .order-button {
        background: #ff7200;
    }
    
    /* set the color of our mobile nav button */
    .dtm .nav-button {
        background: #ff7200;
    }

    /* set the color of our mobile view-full-site button */
    .dtm .vfs {
        background: #31aeb1;
      	max-width: 9.15%;
    }

    .dtm .dtm__in--mv .live-chat-popover {
        max-width: 97%;
        bottom: 1rem;
    }
    

    /*	@Graphics
    * --------------------------------------------------------------------- */
    /* set our desktop background image */
    .dtm__in--dv {

    }

    .dtm__in--dv .has-await--offer::after {
        content: '';
        background: url(/images/desktop/_bg-product.png) no-repeat right bottom;
        position: absolute;
        left: auto;
        top: auto;
        bottom: 0;
        right: -203px;
        width: 100%;
        height: 100%;
    }

    /* Payment graphics for mobile */
    /* these rules make sure the payment graphics are bound to the offer image */
    .dtm__in--mv .offer-area {
        position: relative;
        display: block;
      	z-index: 2;
    }

    /* overlay the payment graphics over the offer image */
    .dtm__in--mv .offer-area .payment {
        /* can control the size of the graphics */
        font-size: 1.4vw;
    }

    /* for screens larger than 640px width */
    @media all and ( min-width : 640px ) {
        .dtm__in--mv .offer-area .payment {
            font-size: 1rem;
        }
    }

    /* set up our path to the sprite sheet */
    [class*="sprite"] {
        background: url(/images/desktop/_sprites.png) no-repeat;
    }

    /* Order Btn (Round) */
    .sprite--btn-ord-round {
        width: 97px; height: 101px; background-position: -5px -2px;
    }

    .sprite--btn-ord-round:hover,
    .sprite--btn-ord-round:focus {
        background-position: -106px -2px;
    }

    /* Order Btn (Rect) */
    .sprite--btn-ord-rect {
        width: 194px; height: 57px; background-position: -6px -109px;
    }

    .sprite--btn-ord-rect:hover,
    .sprite--btn-ord-rect:focus {
        background-position: -6px -170px;
    }

        /* position our order button in the main offer area */
        .gfx-offer .sprite--btn-ord-rect {
            position: absolute; top: 300px; right: 193px;
        }

    /* Process Order  */
    .sprite--btn-order-send {
        width: 194px; height: 57px; background-position: -6px -228px;
    }

    .sprite--btn-order-send:hover,
    .sprite--btn-order-send:focus {
        background-position: -6px -290px;
    }


    /*	@Features & Benefits
        @Desc: thematize the features & benefits
    * --------------------------------------------------------------------- */
    /* set the text color and size of the headline */
    .fb__headline {
        color: #ac242e;
        font: 51px/1 'Din Condensed Bold', sans-serif;
        text-align: center;
    }

    /* set the color & size of our list */
    .fb__list {
        background: white;
        border-color: white;
        line-height: 1.35;
        list-style: none;
      font-family: 'Avenir Next Medium', sans-serif;
    }

    .fb--scalar .fb__list {
        font-size: 2.1em;
    }

    .fb--scalar .fb__list li:before {
        top: 0.9em;
    }

        /* set the size of the features box */
        .fb__list {
            width: 105%;
            left: -7px;
        }

    /* set the color of our bullets */
    .fb__list li:before {
        background: #2363ad;
    }

    .fb__headline,
    .fb__list strong {
        text-transform: uppercase;
    }
  
  .fb__list strong {
    font-weight: normal;
    font-family: 'Avenir Next Bold', sans-serif;
  }

    .list--faq {
        margin: 0;
        font-size: 1.6rem;
    }

    .dtm .list--faq p {
        font-size: inherit;
    }

    .list--faq ul {
        margin-left: 2rem;
    }

    .list--faq .c-list__item {
        position: relative;
        padding: 0;
      	border-color: #ccc;
    }

    .list--faq .c-list__link {
        display: block;
        padding: 10px 30px 10px 10px;
        text-decoration: none;
        background: none;
        border: none;
        width: 100%;
        text-align: left;
        padding-right: 30px;
      	font-weight: bold;
      	color: #4b4b4b;
    }

    .list--faq .icon-chevron-thin-right:before {
        display: inline-block;
        vertical-align: middle;
    }

    .list--faq .icon-chevron-thin-right:before {
        transition: transform 250ms ease-in-out;
    }

    .list--faq .rotate-bottom:before {
        -webkit-transform: rotate(90deg);
        -moz-transform: rotate(90deg);
        transform: rotate(90deg);
    }
  .dtm__in--dv #reviews {
    min-height: 70px;
  }
  .dtm__in--mv #reviews {
    min-height: 20px;
  }
  /* force min height on reviews */
  .dtm__in--dv .reviews {
    min-height: 170px;
}
  
  @media screen and (orientation: portrait) {
    .dtm__in--mv .reviews {
    min-height: 80vw;
}
    .dtm__in--mv .bonus__text {
    font-size: 10vw;
}
}

@media screen and (orientation: landscape) {
    .dtm__in--mv .reviews {
    min-height: 35vw;
}
}

/* qa edits */

.dtm__in--dv .l-nav {
    min-width: 980px;
}
  
  /* mobile color disclaimr */
  .dtm__in--mv .disclaimer__color {
    position: absolute;
    text-decoration: none;
    width: 31%;
    text-align: center;
    font-size: 1.8vw;
    left: 56%;
    top: 94%;
}
  
  .dtm__in--dv .disclaimer__color {
    position: absolute;
    left: 364px;
    top: 317px;
    z-index: 4;
    font: normal 0.75em 'Avenir Next Medium', sans-serif;
}

.dtm__in--dv .hose-row {
    margin: 1rem 0 -2rem;
}
  
  .bonus__text {
    font: 25px/22px 'Avenir Next Bold';
    color: #2363ad;
  	text-transform: uppercase;
      text-align: center;
  }
  .bonus__text small {
    font: 14px 'Avenir Next Medium';
    display: block;
  }
.optin__email {
    display: flex;
    margin: 0 auto;
    max-width: 460px;
    align-items: center;
    background: #c9e8ff;
    padding: 10px;
    font-size: 14px;
}

.optin__email input {
    margin-right: 15px;
}
  
  .dtm__in--dv .perfect-list {
    margin: 0 2em 2em;
}

.perfect-list__title {
    background: #31aeb1;
    text-transform: uppercase;
    color: white;
    text-align: center;
    font-family: 'DIN Bold';
    padding: 0.5em 0;
    font-size: 1.85em;
}

.perfect-list ul {
    margin: 0.4em 0.2em 0.4em 2em;
}

.perfect-list li {
    color: #636363;
    font-family: 'DIN Condensed Bold';
    list-style: none;
    font-size: 2.5em;
    position: relative;
}

.perfect-list li::before {
    display: block;
    width: 10px;
    height: 10px;
    border-radius: 5px;
    background: #2363ad;
    position: absolute;
    left: -0.55em;
    content: "";
    top: 0.6em;
}
  
  .includes__title {
    background: #31aeb1;
    color: white;
    font-family: 'DIN Bold';
}

.includes__items {
    display: flex;
    justify-content: space-between;
    padding: 0;
  align-items: flex-end;
}

.includes__item {
    flex:  0 1 25%;
    text-align: center;
}

.includes__item h6 {
    color: #2363ad;
    font-family: 'DIN Condensed Bold';
    font-size: 0.9em;
  min-height: 65px;
}

.bonus-row .col {
    text-align: left;
}

.includes-spacer > div {
   background: #2363ad;
}

.dtm__in--dv .includes-spacer > div {
    height: 100%;
    min-height: 320px;
    width: 3px;
    margin: 0 12px;
}

.dtm__in--mv .includes-spacer > div {
    width: 100%;
    height: 3px;
    margin: 10px 0;
}

.bonus__title {
    font-size: 35px;
    font-family: 'DIN Condensed Bold';
    color: #636363;
}

.bonus__subtitle {
    font-size: 21px;
    color: #2363ad;
    font-family: 'DIN Condensed Bold';
}

.bonus__subtitle+p {
    font-size: 15px;
    line-height: 1;
}

.bonus-row p {
    font-size: 80%;
    line-height: 1em;
}

  .includes__item div[style*=aspect-ratio],
.includes__item img {
    display: block;
    margin: 0 auto;
}

.bonus-row div[style*=aspect-ratio],
.bonus-row img {
    min-width: 230px;
    margin: 0 auto;
    display: block;
}
  
  .dtm .dtm__in--mv .includes-row,
  .dtm .dtm__in--mv .bonus-row,
  .dtm .dtm__in--mv .includes-spacer {
    display: block;
    width: 100%;
}

@media screen and (orientation: portrait) {
    .dtm__in--mv .bonus-row div[style*=aspect-ratio], .dtm__in--mv .bonus-row img {
        max-width: 300px;
        min-width: 35vw;
    }
	.dtm__in--mv .includes__items {
        flex-wrap: wrap;
    }

    .dtm__in--mv .includes__item {
        flex: 0 1 50%;
    }
}

.dtm__in--mv .perfect-list__title {
    font-size: 2.7rem;
}

.dtm__in--mv .perfect-list ul {
    font-size: 1.5rem;
}

.dtm__in--mv .fb__headline {
    font-size: 5rem;
}

  .solution small {
    font-size: 12px;
}

.includes-box {
    font-size: 2rem;
    border: 1px solid #2363ad;
    padding: 2rem;
    max-width: 90%;
    margin: 2rem auto 0;
    font-family: 'Avenir Next Medium', sans-serif;
}
.includes-box__title {
    color: #2363ad;
    font-size: 1.1em;
    font-weight: bold;
    margin: 0.6em 0 0 0;
}
.includes-box li {
    font-size: 1em;
    list-style: disc;
    color: #636363;
    margin: 0.25em 0 0.25em 1em;
    padding: 0;
}
  .dtm__in--dv .l-nav.sticky {
	position: fixed;
	top: 0;
	width: 100%;
	z-index: 100;
}
.dtm__in--dv .l-nav.sticky+a+.l-outer,
.dtm__in--dv .l-nav.sticky+.l-outer {
	padding-top: 44px;
}
.dtm--reviews .dtm__in--dv article {
    min-width: 580px;
}

.dtm__in--dv .bonus-items__img {
    margin: -10px auto 0;
}
html[class*=spot] #upsellTxt {
    text-align: center;
}
  
.solution {
    font-size: 1.8rem;
}
  
@media all and (-ms-high-contrast:none) {
     *::-ms-backdrop, .dtm--index .dtm__in--dv #content_top { min-height: 3660px; } /* IE11 */
}

.dtm .dtm__in--dv .weather-banner {
    border-top: 3px solid #ff7100;
    border-bottom: 3px solid #ff7100;
    margin: 20px 0 -10px;
}
.dtm .dtm__in--mv .weather-banner {
    border-color: #ff7100
}
.dtm__in--dv #survey .c-modal__item {
    flex: 0 1 32%;
    margin: 0.5%;
}

.dtm__in--dv #survey .c-modal__item:last-of-type {
    flex: 1;
}

/* stack the new grid section with in use shots */
  .dtm .dtm__in--mv .grid--inuse {
    display: block;
}
.dtm__in--mv .grid--inuse .grid__card,
.dtm__in--mv .grid--inuse .grid__card div,
.dtm__in--mv .grid--inuse .grid__card img {
    display: block;
    margin: 0 auto;
}
.dtm__in--mv .grid--inuse .grid__card {
    margin: 1rem auto;
}  
  
  .dtm__in--mv .grid__card:first-of-type figcaption br {
    display: none;
  }

.dtm__in--mv .bg-section h2 {
    max-width: 90%;
    margin: 0 auto;
}
  
.dtm__in--mv .grid__card li {
    min-height: 390px;
}

  .dtm__in--mv .slide--alpha {
	margin: auto;
  }
  
  .dtm__in--mv .fp-nav {
    z-index: 100;
  }
  
  #order {
    display: none;
  }
  
  
	.dtm--upsell .dtm__in--mv .l-outer {
	    max-width: none;
	}

	.dtm__in--mv #content_top {
    margin-top: 0;
  }

	.\@b .dtm__in--mv .o-box--btn--confirm {
		font-size: 2rem;
		padding: 1.5rem 3rem;
	}
  
  .dtm__in--mv .l-nav__in a {
    width: 33%;
    text-align: center;
    font-size: 1.6rem;
}
  
.policy-body ol {
    margin-left: 2rem;
}

  /*
   * NOTE: this rule below is necessary in order to keep this button from overlapping the order button on mobile
   * */
  @media all and (orientation: landscape) {
    .dtm__in--mv .live-chat-popover {
      top: auto !important;
    }
  }
  
.dtm__in--mv .offer__desc a {
    display: block;
}
  
@media all and (-ms-high-contrast:none) {
     *::-ms-backdrop, .c-brand--item__group {
     	flex-direction: column;
     	justify-content: center;
     	min-height: 130px;
     }
}

.dtm__in--mv .c-brand__headline--sm,
  .dtm__in--mv .c-brand--subpage > h2 {
    font-family: 'Avenir Next Bold', sans-serif;
  }
  
.dtm--subpage h3 {
    font-size: 1.6rem;
    line-height: 1;
    margin: 2rem 0 0.5rem;
    font-family: 'Avenir Next Bold', sans-serif;
}
  
.dtm .policy-body,
.dtm .c-modal__fieldset {font-family: 'Avenir Next Medium', sans-serif;}
.dtm .c-phase__status figcaption { width: 6.5em; }
.dtm__in--mv .c-phase__status figcaption { width: 6.5rem; }
.offer__phone {
    border-radius: 1rem;
    border: 3px solid #2363ad;
    padding: 1rem;
    display: inline-block;
}
  .offer__phone .icon {
    display: inline-block;
  }
  
.dtm .dtm__in--mv .offer__phone {
    min-width: 32rem;
	margin: 1rem 0 0;
}

.dtm__in--mv .offer__desc.offer__phone a {
    display: inline-block;
}

.dtm .c-brand--rebuttal th
{
    text-align:center;
    background:#0e529e;
    font-size: 2rem;
    padding: 1rem;
    font-weight: normal;
}

.c-upsell__prefix {
    font-style: normal;
}

.register-button{
    
    background: #f84100;
}
</style>

<link rel="stylesheet" href="https://use.typekit.net/hdk2ibq.css">
<link rel="stylesheet" href="/css/shopping-cart.css">
<link rel="stylesheet" href="/css/payment-form.css?v=4"> 
<link rel="stylesheet" href="/css/offer.css?v=9">
