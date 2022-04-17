From 700b0bdea872f4c00182b2bd925b41fe03f8d222 Mon Sep 17 00:00:00 2001
From: Aidan Hall <aidan.hall@outlook.com>
Date: Tue, 2 Jun 2020 14:41:53 +0000
Subject: [PATCH] Prevents hiding the border if layout is floating.

---
 dwm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/dwm.c b/dwm.c
index 4465af1..2dd959d 100644
--- a/dwm.c
+++ b/dwm.c
@@ -1282,6 +1282,14 @@ resizeclient(Client *c, int x, int y, int w, int h)
 	c->oldw = c->w; c->w = wc.width = w;
 	c->oldh = c->h; c->h = wc.height = h;
 	wc.border_width = c->bw;
+	if (((nexttiled(c->mon->clients) == c && !nexttiled(c->next))
+	    || &monocle == c->mon->lt[c->mon->sellt]->arrange)
+	    && !c->isfullscreen && !c->isfloating
+	    && NULL != c->mon->lt[c->mon->sellt]->arrange) {
+		c->w = wc.width += c->bw * 2;
+		c->h = wc.height += c->bw * 2;
+		wc.border_width = 0;
+	}
 	XConfigureWindow(dpy, c->win, CWX|CWY|CWWidth|CWHeight|CWBorderWidth, &wc);
 	configure(c);
 	XSync(dpy, False);
-- 
2.26.2

