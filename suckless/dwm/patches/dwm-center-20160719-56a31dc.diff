diff --git a/config.def.h b/config.def.h
index fd77a07..5bf4860 100644
--- a/config.def.h
+++ b/config.def.h
@@ -26,9 +26,9 @@ static const Rule rules[] = {
 	 *	WM_CLASS(STRING) = instance, class
 	 *	WM_NAME(STRING) = title
 	 */
-	/* class      instance    title       tags mask     isfloating   monitor */
-	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
-	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
+	/* class      instance    title       tags mask     iscentered     isfloating   monitor */
+	{ "Gimp",     NULL,       NULL,       0,            0,             1,           -1 },
+	{ "Firefox",  NULL,       NULL,       1 << 8,       0,             0,           -1 },
 };
 
 /* layout(s) */
diff --git a/dwm.c b/dwm.c
index b2bc9bd..72c9497 100644
--- a/dwm.c
+++ b/dwm.c
@@ -93,7 +93,7 @@ struct Client {
 	int basew, baseh, incw, inch, maxw, maxh, minw, minh;
 	int bw, oldbw;
 	unsigned int tags;
-	int isfixed, isfloating, isurgent, neverfocus, oldstate, isfullscreen;
+	int isfixed, iscentered, isfloating, isurgent, neverfocus, oldstate, isfullscreen;
 	Client *next;
 	Client *snext;
 	Monitor *mon;
@@ -138,6 +138,7 @@ typedef struct {
 	const char *instance;
 	const char *title;
 	unsigned int tags;
+	int iscentered;
 	int isfloating;
 	int monitor;
 } Rule;
@@ -298,6 +299,7 @@ applyrules(Client *c)
 		&& (!r->class || strstr(class, r->class))
 		&& (!r->instance || strstr(instance, r->instance)))
 		{
+			c->iscentered = r->iscentered;
 			c->isfloating = r->isfloating;
 			c->tags |= r->tags;
 			for (m = mons; m && m->num != r->monitor; m = m->next);
@@ -1066,6 +1068,11 @@ manage(Window w, XWindowAttributes *wa)
 	           && (c->x + (c->w / 2) < c->mon->wx + c->mon->ww)) ? bh : c->mon->my);
 	c->bw = borderpx;
 
+	if(c->iscentered) {
+		c->x = (c->mon->mw - WIDTH(c)) / 2;
+		c->y = (c->mon->mh - HEIGHT(c)) / 2;
+	}
+
 	wc.border_width = c->bw;
 	XConfigureWindow(dpy, w, CWBorderWidth, &wc);
 	XSetWindowBorder(dpy, w, scheme[SchemeNorm][ColBorder].pixel);
