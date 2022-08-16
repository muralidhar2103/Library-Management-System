from tkinter import *
from PIL import ImageTk,Image
from tkinter import messagebox
import pymysql

mypass = "2001"
mydatabase="library"

con = pymysql.connect(host="localhost",user="root",password=mypass,database=mydatabase)
cur = con.cursor()

bookTable = "Book"
issueTable="Issue"

def Return(login):
    global en1,ReturnBtn,lb1,labelFrame,quitBtn,Canvas1,root

    id=en1.get()
    issuedBIDs = []
    getIssuedBooks = "CALL get_all_borrowed_books("+ str(login) +")"
    try:
        cur.execute(getIssuedBooks)
        con.commit()
        for i in cur:
            issuedBIDs.append(i[0])
        if id not in issuedBIDs:
            messagebox.showinfo("Error","Book has not been issued to you")
        else:
            returnSql="CALL return_book(" + str(login) + "," + str(id) + ")"
            try:
                cur.execute(returnSql)
                con.commit()
                messagebox.showinfo("Success","Book returned Succesfully")
            except pymysql.Error as e:
                print("Error %d: %s" % (e.args[0], e.args[1]))
                messagebox.showinfo("Error","Could Not Return Book.Please try again")
            except:
                messagebox.showinfo("Error","Could Not Return Book.Please try again")
    except pymysql.Error as e:
        print("Error %d: %s" % (e.args[0], e.args[1]))
        messagebox.showinfo("Error","Something went Wrong Please Try again")

def returnBook(login): 
    
    global en1,ReturnBtn,lb1,labelFrame,quitBtn,Canvas1,root
    
    root = Tk()
    root.title("Library")
    root.minsize(width=400,height=400)
    root.geometry("600x500")
    
    
    same=True
    n=0.3
    
    background_image =Image.open("library.jpg")
    [imageSizeWidth, imageSizeHeight] = background_image.size
    
    newImageSizeWidth = int(imageSizeWidth*n)
    if same:
        newImageSizeHeight = int(imageSizeHeight*n) 
    else:
        newImageSizeHeight = int(imageSizeHeight/n)

    
    Canvas1 = Canvas(root)
    
    Canvas1.config(bg="white",width = newImageSizeWidth, height = newImageSizeHeight)
    Canvas1.pack(expand=True,fill=BOTH)
    
    labelFrame = Frame(root,bg='black')
    labelFrame.place(relx=0.1,rely=0.1,relwidth=0.8,relheight=0.1)
        
    headingFrame1 = Frame(root,bg="#333945",bd=5)
    headingFrame1.place(relx=0.25,rely=0.02,relwidth=0.5,relheight=0.07)
        
    headingFrame2 = Frame(headingFrame1,bg="#EAF0F1")
    headingFrame2.place(relx=0.01,rely=0.05,relwidth=0.98,relheight=0.9)
        
    headingLabel = Label(headingFrame2, text="RETURN BOOK", fg='black')
    headingLabel.place(relx=0.25,rely=0.15, relwidth=0.5, relheight=0.5)   
        

    lb1 = Label(labelFrame,text="Enter Book id : ", bg='black', fg='white')
    lb1.place(relx=0.05,rely=0.3)
        
    en1 = Entry(labelFrame)
    en1.place(relx=0.3,rely=0.3, relwidth=0.62)

    labelFrame = Frame(root,bg='black')
    labelFrame.place(relx=0.1,rely=0.25,relwidth=0.8,relheight=0.5)
    
    y = 0.25
    
    Label(labelFrame, text="%-10s%-30s%-20s%-30s%-20s"%('BID','Title','Subject','Author','Status'),bg='black',fg='white').place(relx=0.07,rely=0.1)
    Label(labelFrame, text="-------------------------------------------------------------------------------------------",bg='black',fg='white').place(relx=0.05,rely=0.2)

    getBorrowed = "CALL get_all_borrowed_books("+ str(login) +")"
    try:
        cur.execute(getBorrowed)
        con.commit()
        for i in cur:
            Label(labelFrame, text="%-10s%-30s%-20s%-30s%-20s"%(i[0],i[1],i[2],i[3],i[4]),bg='black',fg='white').place(relx=0.07,rely=y)
            y += 0.1
    except:
        messagebox.showinfo("Bad Format","Can't fetch files from database")
    
    ReturnBtn = Button(root,text="Return",bg='#264348', fg='white',command= lambda:Return(login))
    ReturnBtn.place(relx=0.28,rely=0.85, relwidth=0.18,relheight=0.08)
    
    quitBtn = Button(root,text="Quit",bg='#455A64', fg='white', command=root.quit)
    quitBtn.place(relx=0.53,rely=0.85, relwidth=0.18,relheight=0.08)
    
    root.mainloop()