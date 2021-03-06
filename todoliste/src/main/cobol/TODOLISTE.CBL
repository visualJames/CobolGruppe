       IDENTIFICATION DIVISION.
       PROGRAM-ID. TODOLISTE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
         FILE-CONTROL.
         SELECT TDLIST ASSIGN TO 'todolist.txt'
            ORGANIZATION IS LINE SEQUENTIAL.
         SELECT PRINT-FILE ASSIGN TO 'todolist.txt'
            ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
          FD TDLIST.
          01 TDLIST-FILE.
             05 ITEM-ID PIC 9(5).
             05 ITEM-CONTENT PIC X(35).
             05 ITEM-DATE PIC X(21).
             05 ITEM-STATUS PIC 9.
             05 ITEM-COLOR PIC 9.
             05 ITEM-TAG PIC 9.
                88 NONE     VALUE 0.
                88 WORK     VALUE 1.
                88 HOME     VALUE 2.
       WORKING-STORAGE SECTION.
       01 TEMP-FIELDS.
        05 CURRENT-DATE.
          10  WS-CURRENT-YEAR         PIC 9(04).
          10  WS-CURRENT-MONTH        PIC 9(02).
          10  WS-CURRENT-DAY          PIC 9(02).
        05  ITEM-TO-DELETE          PIC 999.
        05  NUMBER-OF-TODOS         PIC 999.
           88 LIST-IS-EMPTY VALUE ZERO.
        05  COUNTER                 PIC 999.
        05  TODOLISTE.
            07  TODO-ITEM PIC X(35) OCCURS 999.
        05 FONTCOLOR                   PIC X(6).
        05 STATUS-STRING               PIC X(6).
        01 WS-EOF PIC A(1).
        01 WS-TDLIST.
           05 ITEM-ID PIC 9(5).
           05 ITEM-CONTENT PIC X(35).
           05 ITEM-DATE PIC X(21).
           05 ITEM-STATUS PIC 9.
              88 TODO     VALUE 0.
              88 DOING    VALUE 1.
              88 DONE     VALUE 2.
              88 CANCELED VALUE 3.
           05 ITEM-COLOR PIC 9.
              88 BLACK    VALUE 0.
              88 BLUE     VALUE 1.
              88 RED      VALUE 2.
              88 GREEN    VALUE 3.
              88 ORANGE   VALUE 4.
           05 ITEM-TAG PIC 9.
              88 NONE     VALUE 0.
              88 WORK     VALUE 1.
              88 HOME     VALUE 2.
       LINKAGE SECTION.
        COPY todoactions.
        COPY todoitem.
       PROCEDURE DIVISION USING TODO-ACTION NEW-TODO-ITEM.
           EVALUATE TRUE
           WHEN ACTION-SHOW
              PERFORM READ-TODOLIST-FROM-FILE
           WHEN ACTION-ADD
              PERFORM ADD-NEW-TODO-ITEM
           WHEN ACTION-DELETE
              PERFORM CLEAR-LIST
           END-EVALUATE
           GOBACK
          .

       ADD-NEW-TODO-ITEM SECTION.
           OPEN INPUT TDLIST
             PERFORM UNTIL WS-EOF='Y'
                 READ TDLIST INTO WS-TDLIST
                    AT END MOVE 'Y' TO WS-EOF
                    NOT AT END ADD 1 TO NUMBER-OF-TODOS
                 END-READ
             END-PERFORM
           CLOSE TDLIST
		   MOVE FUNCTION CURRENT-DATE TO ITEM-DATE IN WS-TDLIST
           MOVE NEW-TODO-ITEM
             TO TODO-ITEM (NUMBER-OF-TODOS)
           ADD 1 TO ITEM-ID IN WS-TDLIST
           MOVE NEW-TODO-ITEM
             TO ITEM-CONTENT IN WS-TDLIST

           OPEN EXTEND TDLIST
           WRITE TDLIST-FILE FROM WS-TDLIST
           CLOSE TDLIST

          EXIT.

       CLEAR-LIST SECTION.
          OPEN OUTPUT TDLIST
          CLOSE TDLIST
          EXIT.

       DISPLAY-ITEM SECTION.
      *hiermit werden im String ITEM-Content alle %20 durch drei
      *Leerzeichen ersetzt
          INSPECT ITEM-Content IN WS-TDLIST REPLACING ALL "%20"
          BY "   "
          EVALUATE TRUE
              WHEN BLACK MOVE "black" TO FONTCOLOR
              WHEN RED MOVE "red" TO FONTCOLOR
              WHEN BLUE MOVE "blue" TO FONTCOLOR
              WHEN GREEN MOVE "green" TO FONTCOLOR
              WHEN ORANGE MOVE "orange" TO FONTCOLOR
              WHEN OTHER MOVE "black" TO FONTCOLOR
          END-EVALUATE
		  EVALUATE TRUE
              WHEN TODO MOVE "ToDo----" TO STATUS-STRING
              WHEN DOING MOVE "Doing---" TO STATUS-STRING
              WHEN DONE MOVE "Done----" TO STATUS-STRING
              WHEN CANCELED MOVE "Canceled" TO STATUS-STRING
          END-EVALUATE
          DISPLAY "<li style=""color: " FONTCOLOR """>"
                    "<label>"
                    "<input type = ""checkbox"" "
                    "name = ""todo"" "
                    "id = "" " ITEM-ID IN WS-TDLIST " "">"
                    STATUS-STRING " "
      	            ITEM-DATE IN WS-TDLIST(7:2) "."
                    ITEM-DATE IN WS-TDLIST(5:2) ", "
                    ITEM-DATE IN WS-TDLIST(9:2) ":"
                    ITEM-DATE IN WS-TDLIST(11:2) " "
                    ITEM-CONTENT IN WS-TDLIST "</li> </label>"
          EXIT.

       DELETE-ITEM SECTION.
           MOVE SPACES TO TODO-ITEM (ITEM-TO-DELETE)
           PERFORM WITH TEST AFTER
             VARYING COUNTER FROM ITEM-TO-DELETE BY 1 UNTIL
                  COUNTER = NUMBER-OF-TODOS
                MOVE TODO-ITEM(COUNTER + 1)
                  TO TODO-ITEM(COUNTER)
           END-PERFORM
          EXIT.
       READ-TODOLIST-FROM-FILE SECTION.
             OPEN INPUT TDLIST
             DISPLAY "<ul>"
             PERFORM UNTIL WS-EOF='Y'
                 READ TDLIST INTO WS-TDLIST
                    AT END MOVE 'Y' TO WS-EOF
                    NOT AT END PERFORM DISPLAY-ITEM
                 END-READ
             END-PERFORM
             DISPLAY "</ul>"
             CLOSE TDLIST
          EXIT.

       END PROGRAM TODOLISTE.
