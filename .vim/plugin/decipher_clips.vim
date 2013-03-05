vmap ,ro <Esc>:call Rows()<CR>
vmap ,co <Esc>:call Cols()<CR>
vmap ,ch <Esc>:call Choice()<CR>
vmap ,rl <Esc>:call Relabel()<CR>
vmap ,avv <Esc>:call AddValues()<CR>
vmap ,avl <Esc>:call AddValuesLow()<CR>
vmap ,avh <Esc>:call AddValuesHigh()<CR>
vmap ,ag <Esc>:call AddGroups()<CR>
vmap ,mr <Esc>:call MakeRadio()<CR>
vmap ,mc <Esc>:call MakeCheckbox()<CR>
vmap ,ma <Esc>:call MakeTextarea()<CR>
vmap ,mt <Esc>:call MakeText()<CR>
vmap ,mn <Esc>:call MakeNumber()<CR>
vmap ,mv <Esc>:call MakeRating()<CR>
vmap ,ms <Esc>:call MakeSelect()<CR>
vmap ,mg <Esc>:call MakeGroups()<CR>
vmap ,re <Esc>:call MakeResource()<CR>
vmap ,cs <Esc>:call SurveyComment()<CR>
vmap ,sw <Esc>:call Switcher()<CR>
vmap ,ca <Esc>:call Case()<CR>
vmap ,mp <Esc>:call Pipe()<CR>
vmap ,pp <Esc>:call Case()<CR><Esc>:call Pipe()<CR>
nmap ,ss <Esc>ggv<S-(><S-$><S-g>:call CleanUp()<CR><Esc>:call NewSurvey()<CR>
vmap ,cl <Esc>:call CleanUp()<CR>
vmap ,aa <Esc>:call AddAlts()<CR>
vmap ,so <Esc>:call Sort()<CR>
vmap ,cq <Esc>:call CommentQuestion()<CR>
nmap ,ee <Esc>i exclusive="1" randomize="0"<Esc>
nmap ,rr <Esc>i randomize="0"<Esc>
nmap ,on <Esc>i open="1" openSize="25" randomize="0"<Esc>
nmap ,aa <Esc>i aggregate="0" percentages="0"<Esc>
nmap ,oo <Esc>i optional="1"<Esc>
nmap ,sh <Esc>i shuffle="rows"<Esc>
nmap ,br <Esc>i<br/> <Esc>
nmap ,tt <Esc>i  <term cond=""></term><Esc>


function! CommentQuestion()
'<,'>python << EOF
try:
    import vim
    input = "\n".join(vim.current.range[:])
    vim.current.range[:] = ("  <comment>%s</comment>" % input.strip()).split("\n")

except Exception, e:
    print e
EOF
endfunction


function! Sort()
'<,'>python << EOF
try:
    import vim
    input = vim.current.range[:]
    input.sort()
    vim.current.range[:] = input

except Exception, e:
    print e
EOF
endfunction


function! AddAlts()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("(<(row|col|choice|group).*?>)(.*?)(</(row|col|choice|group)>)", "\g<1><alt>\g<3></alt>\g<3>\g<4>", input)
    title = re.compile("(<title>)(.*?)(</title>)", re.DOTALL)
    input = title.sub("\g<1>\g<2>\g<3>\n<alt>\g<2></alt>", input)
    vim.current.range[:] = input.split("\n")

except Exception, e:
    print e
EOF
endfunction

function! CleanUp()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)

    #CLEAN UP SPACES 
    input = re.sub("\n +\n", "\n\n", input)

    #REPLACE SMART QUOTES, ELLIPSIS AND EM-DASHES
    funkyChars = [(chr(133),'...'),(chr(145),"'"),(chr(146),"'"),(chr(147),'"'),(chr(148),'"'),(chr(151),'--')]

    for pair in funkyChars:
        input = input.replace(pair[0],pair[1])

    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{3,}", "\n\n", input)

    #REPLACE AMPERSTANDS WITH ENTITIES
    input = input.replace("&", "&#38;")
    vim.current.range[:] = input.split("\n")

except Exception, e:
    print e
EOF
endfunction


function! NewSurvey()
python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.buffer[:])
    
    exit
    HEADER = """<?xml version="1.0" encoding="UTF-8"?>
<survey name="Survey" alt="" autosave="0" extraVariables="source,list,url,record,ipAddress" compat="24" state="testing" newVirtual="1" setup="time,quota,term" ss:disableBackButton="1" unique="">

<samplesources default="0">
  <samplesource list="0" title="default">
    <exit cond="qualified"><b>Thanks again for completing the survey!<br/><br/>Your feedback and quick response to this survey are greatly appreciated.</b></exit>
    <exit cond="terminated"><b>Thank you for your input!</b></exit>
    <exit cond="overquota"><b>Thank you for your input!</b></exit>
  </samplesource>
</samplesources>"""
    
    FOOTER = """<marker name="qualified"/>

</survey>"""
    
    vim.current.buffer[:] = ("%s\n\n%s\n\n%s" % (HEADER, input, FOOTER)).split("\n")


except Exception, e:
    print e
EOF
endfunction

function! Pipe()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]

    # get rid of blank lines
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")

    vim.current.range[:] = ("<pipe label=\"\" capture=\"\">\n  %s\n</pipe>" % input.strip()).split("\n")
   

except Exception, e:
    print e
EOF
endfunction


function! Case()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    vim.current.range[:] = [x for x in vim.current.range[:] if x]
    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)
        
    #CLEAN UP SPACES
    input = re.sub("\n +\n", "\n\n", input)
        
    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{2,}", "\n", input)
        
    input = input.strip().split("\n")
        
    for x in range(0,len(input)):
        input[x] = re.sub("^[a-zA-Z0-9]{1,2}[\.:\)][ \t]+", "\n", input[x])
        count = 0
        for x in input:
            vim.current.range[count] = "  <case label=\"c%s\" cond=\"\">%s</case>" % (str(count+1), input[count].strip())
            count += 1
        vim.current.range[count] = "  <case label=\"c%s\" cond=\"1\">Undefined</case>" % str(count+1)

except Exception, e:
    print e
EOF
endfunction


function! Relabel()
'<,'>python << EOF
try:
    import vim
    import re
    input = vim.current.range[:]
    startlabel = re.findall("label=['\"]\w+['\"]", input[0])[0].replace("label=","").strip("\"'") # get first label
    nonalphalabel = re.sub("[a-zA-Z]*", "", startlabel) # get non-alpha components of first label
    
    alphanum = False # first label does not contain numbers unless found otherwise
    if nonalphalabel.isdigit():
        startindex = int(nonalphalabel) # we'll increment from numeric portion of the first label (e.g. the "0" in "r0")
        alphanum = True
    else:
        startindex = ord(startlabel) # we'll increment from the alphabetical label (e.g. "A" if the first label is "A")

# the new labels with either be incremented from the numeric portion of the first label
# or, they'll be incremented from a length == 1 alphabetical label
    i=-1
    for cnt in range(len(input)):
        if re.findall("<col|<row|<choice", input[cnt].strip()):
          i+=1
          if alphanum:
            newlabel = re.sub("[0-9]+", str(startindex + i), startlabel)
          else:
            newlabel = chr(startindex + i)
          vim.current.range[cnt] = re.sub("label=['\"]\w+['\"]", "label=\"%s\"" % newlabel, input[cnt])


except Exception, e:
    print e
EOF
endfunction

function! Rows()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:]).strip()
    vim.current.range[:] = [x for x in vim.current.range[:] if x]
    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)
    
    #CLEAN UP SPACES
    input = re.sub("\n +\n", "\n\n", input)
    
    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{2,}", "\n", input)
    
    input = input.strip().split("\n")
    
    for x in range(0,len(input)):
        input[x] = re.sub("^[a-zA-Z0-9]{1,2}[\.:\)][ \t]+", "\n", input[x])
        input[x] = re.sub('^"\s+', "", input[x])    
    count = 0
    for x in input:
        vim.current.range[count] =  "  <row label=\"r%s\">%s</row>" % (str(count+1), input[count].strip())
        count += 1

except Exception, e:
    print e
EOF
endfunction

function! Cols()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    vim.current.range[:] = [x for x in vim.current.range[:] if x]
    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)

    #CLEAN UP SPACES
    input = re.sub("\n +\n", "\n\n", input)

    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{2,}", "\n", input)

    input = input.strip().split("\n")

    for x in range(0,len(input)):
        input[x] = re.sub("^[a-zA-Z0-9]{1,2}[\.:\)][ \t]+", "\n", input[x])
        input[x] = re.sub('^"\s+', "", input[x])                            
    count = 0
    for x in input:
        vim.current.range[count] =  "  <col label=\"c%s\">%s</col>" % (str(count+1), input[count].strip())
        count += 1
  
except Exception, e:
    print e
EOF
endfunction

function! Choice()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    vim.current.range[:] = [x for x in vim.current.range[:] if x]
    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)

    #CLEAN UP SPACES
    input = re.sub("\n +\n", "\n\n", input)

    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{2,}", "\n", input)

    input = input.strip().split("\n")
    for x in range(0,len(input)):
        input[x] = re.sub("^[a-zA-Z0-9]{1,2}[\.:\)][ \t]+", "\n", input[x])
        input[x] = re.sub('^"\s+', "", input[x])                            
    count = 0
    for x in input:
        vim.current.range[count] = "  <choice label=\"ch%s\">%s</choice>" % (str(count+1), input[count].strip())
        count += 1

except Exception, e:
    print e
EOF
endfunction

function! AddValuesLow()
'<,'>python << EOF
try:
    import vim
    input = vim.current.range[:]
    while "" in input:
        del input[input.index("")]
    count = 1
    for x in input:
        if "alt" in x:
            x = x.replace("\" alt=\"", "\" value=\"" + str(count) + "\" alt=\"")
            count += 1
        else:
            x = x.replace("\">", "\" value=\"" + str(count) + "\">")
            count += 1
        vim.current.range[count-2] = x
    
except Exception, e:
    print e
EOF
endfunction

function! AddValuesHigh()
'<,'>python << EOF
try:
    import vim
    input = vim.current.range[:]
    while "" in input:
        del input[input.index("")]
    length = len(input)
    count = 0
    for x in input:
        if "alt" in x:
            x = x.replace("\" alt=\"", "\" value=\"" + str(length - count) + "\" alt=\"")
            count += 1
        else:
            x = x.replace("\">", "\" value=\"" + str(length - count) + "\">")
            count += 1
        vim.current.range[count-1] = x

except Exception, e:
    print e
EOF
endfunction
 

function! MakeRadio()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1) 
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    
    # get rid of blank lines
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")
    
    # see if there is a number
    if label[0].isdigit():
        label = "Q" + label

    #capture the title
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        input_index = min(input_array)
        title = input[0:input_index]

    # remove title from input
    input = input.replace(title, "")
    
    output = input
    #test for and adjust comment for 2d question
    if "<comment>" not in input:
        if (("row" in output) or ("rows" in output)) and (("col" in output) or ("cols" in output)):
            comment = "<comment>Select one in each row</comment>\n"
        else:
            comment = "<comment>Select one</comment>\n"

    # compose our new radio question
    if "<comment>" not in input:
      vim.current.range[:] = ("<radio label=\"%s\">\n  <title>%s</title>\n  %s  %s\n</radio>\n<suspend/>" % (label.strip(), title.strip(), comment, output)).split("\n")
    else:
      vim.current.range[:] = ("<radio label=\"%s\">\n  <title>%s</title>\n  %s\n</radio>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e  
EOF
endfunction   

function! MakeCheckbox()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       

    # isolate the label
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    # isolate the rest
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    
    # remove spaces
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")

    # add a q to the label if its a digit
    if label[0].isdigit():
        label = "Q" + label

    # isolate the title from either a macro or a bunch of rows or columns
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        input_index = min(input_array)
        title = input[0:input_index]
    
    # take the title out of the input
    input = input.replace(title, "")

    # add the all important line breakage
    output = input

    # set the appropriate comment
    comment = "<comment>Select all that apply</comment>\n"

    # compose the question
    if "<comment>" not in input:
        vim.current.range[:] = ("<checkbox label=\"%s\" atleast=\"1\">\n  <title>%s</title>\n  %s  %s\n</checkbox>\n<suspend/>" % (label.strip(), title.strip(), comment, output)).split("\n")
    else:
        vim.current.range[:] = ("<checkbox label=\"%s\" atleast=\"1\">\n  <title>%s</title>\n  %s\n</checkbox>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! MakeResource()
'<,'>python << EOF
try:
    import vim
    input = [x.strip() for x in vim.current.range[:]]
    for i in range(len(input)):
      if input[i] != "":
        vim.current.range[i] = '<res label="">%s</res>' % input[i]
    
except Exception, e:
    print e
EOF
endfunction
 

function! SurveyComment()
'<,'>python << EOF
try:
    import vim
    input = "\n".join(vim.current.range[:])
    vim.current.range[:] = ("<html label=\"\" where=\"survey\">%s<br/><br/></html>" % input).split('\n')
    
except Exception, e:
    print e
EOF
endfunction

function! MakeTextarea()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       
 
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")
    if label[0].isdigit():
        label = "Q" + label

    #ISOLATE TITLE TO MACRO OR QUESTION ELEMENT OPEN ANGLE BRACKET
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        if len(input_array) == 0:
            title = input
        else:
          input_index = min(input_array)
          title = input[0:input_index]

    #REMOVE THE TITLE TEXT
    input = input.replace(title, "")

    # add the all important line breakage
    output = input

    #COMPOSE OUR QUESTION
    if "<comment>" not in input:
        if len(input_array) == 0:
            comment = "Please be as specific as possible"
            vim.current.range[:] = ("<textarea label=\"%s\" optional=\"0\" comment=\"%s\" title=\"%s\"/>\n<suspend/>" % (label.strip(), comment, title.strip())).split("\n")
        else:
            comment = "<comment>Please be as specific as possible</comment>\n"
            vim.current.range[:] = ("<textarea label=\"%s\" optional=\"0\">\n  <title>%s</title>\n  %s  %s\n</textarea>\n<suspend/>" % (label.strip(), title.strip(), comment, output)).split("\n")
    else:
        vim.current.range[:] = ("<textarea label=\"%s\" optional=\"0\">\n  <title>%s</title>\n  %s\n</textarea>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! MakeText()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")
    if label[0].isdigit():
        label = "Q" + label

    #ISOLATE TITLE TO MACRO OR QUESTION ELEMENT OPEN ANGLE BRACKET
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        if len(input_array) == 0:
            title = input
        else:
          input_index = min(input_array)
          title = input[0:input_index]



    #REMOVE THE TITLE TEXT
    input = input.replace(title, "")

    # add the all important line breakage
    output = input

    #COMPOSE OUR QUESTION
    if "<comment>" not in input:
        if len(input_array) == 0:
            comment = "Please be as specific as possible"
            vim.current.range[:] = ("<text label=\"%s\" size=\"40\" optional=\"0\" comment=\"%s\" title=\"%s\"/>\n<suspend/>" % (label.strip(), comment, title.strip())).split("\n")
        else:
            comment = "<comment>Please be as specific as possible</comment>\n"
            vim.current.range[:] = ("<text label=\"%s\" size=\"40\" optional=\"0\">\n  <title>%s</title>\n  %s  %s\n</text>\n<suspend/>" % (label.strip(), title.strip(), comment, output)).split("\n")
    else:
        vim.current.range[:] = ("<text label=\"%s\" size=\"40\" optional=\"0\">\n  <title>%s</title>\n  %s\n</text>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! MakeNumber()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")
 
    if label[0].isdigit():
        label = "Q" + label

    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        if len(input_array) == 0:
            title = input
        else:
          input_index = min(input_array)
          title = input[0:input_index]

    input = input.replace(title, "")
    output = input

    if "<comment>" not in input:
        if len(input_array) == 0 and 0:
            comment = "Please enter a whole number"
            vim.current.range[:] = ("<number label=\"%s\" size=\"3\" optional=\"0\" comment=\"%s\" title=\"%s\"/>\n<suspend/>" % (label.strip(), comment, title.strip())).split("\n")
        else:
            comment = "<comment>Please enter a whole number</comment>\n"
            vim.current.range[:] = ("<number label=\"%s\" size=\"3\" optional=\"0\">\n  <title>%s</title>\n  %s  %s\n</number>\n<suspend/>" % (label.strip(), title.strip(), comment, output)).split("\n")
    else:
        vim.current.range[:] = ("<number label=\"%s\" size=\"3\" optional=\"0\">\n  <title>%s</title>\n  %s\n</number>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! MakeSelect()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       
    #isolate label and the rest
    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]
    
    #remove extra blank lines
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")

    #Add a q if the first character is a digit
    if label[0].isdigit():
        label = "Q" + label

    #isolate the title
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        input_index = min(input_array)
        title = input[0:input_index]

    #remove the title
    input = input.replace(title, "")

    # add the all important line breakage
    output = "\n  " + input

    # compose the select question
    vim.current.range[:] = ("<select label=\"%s\" optional=\"0\">\n  <title>%s</title>  %s\n</select>\n<suspend/>" % (label.strip(), title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! MakeRating()
'<,'>python << EOF
try:
    import vim
    import re
    input = "\n".join(vim.current.range[:])
    input = re.sub("^\s*","",input,1)       
    while "\n\n" in input:
        input = input.replace("\n\n", "\n")

    label = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[1]
    input = re.split(r"^([a-zA-Z0-9-_]+)+(\.|:|\)|\s)", input, 1)[-1]

    if label[0].isdigit():
        label = "Q" + label
    if "@" in input:
        title = input[0:(input.index("@"))]
    else:
        input_array = []
        if "<row" in input:
            input_array.append(input.index("<row"))
        if "<col" in input:
            input_array.append(input.index("<col"))
        if "<choice" in input:
            input_array.append(input.index("<choice"))
        if "<comment" in input:
            input_array.append(input.index("<comment"))
        if "<group" in input:
            input_array.append(input.index("<group"))
        if "<net" in input:
            input_array.append(input.index("<net"))
        if "<exec" in input:
            input_array.append(input.index("<exec"))
        input_index = min(input_array)
        title = input[0:input_index]

    input = input.replace(title, "")

    output = input
    shffl = ""
    style = ""
    
    #DETERMINE IF WE NEED A 1D OR 2D COMMENT, SHUFFLE 2D ROWS OR COLS, ADD AVERAGES attribute.
    if (("row" in output) or ("rows" in output)) and (("col" in output) or ("cols" in output)):
        comment = "<comment>Select one in each row</comment>\n"
        s = output.split("    ")
        for x in s:
            if x.count("value=") > 0:
                if x.count("<col") > 0:
                    shffl = "\" shuffle=\"rows"
                elif x.count("<row") > 0:
                    shffl = "\" shuffle=\"cols"
    else:
        comment = "<comment>Select one</comment>\n"

    if "<comment>" not in input:
        vim.current.range[:] = ("<radio label=\"%s%s%s\" type=\"rating\">\n  <title>%s</title>\n  %s  %s\n</radio>\n<suspend/>" % (label.strip(), shffl, style, title.strip(), comment, output)).split("\n")
    else:
        vim.current.range[:] = ("<radio label=\"%s%s%s\" type=\"rating\">\n  <title>%s</title>\n  %s\n</radio>\n<suspend/>" % (label.strip(), shffl, style, title.strip(), output)).split("\n")

except Exception, e:
    print e
EOF
endfunction

function! Switcher()
'<,'>python << EOF
try:
    import vim
    import notetab
    import re
    input = vim.current.range[:]

    for i in range(len(input)):
        if "<row" in input[i]:
            objx = "row"
            labx = "r"
            objy = "col"
            laby = "c"
        elif "<col" in input[i]:
            objx = "col"
            labx = "c"
            objy = "row"
            laby = "r"
        input[i] = re.sub("(<|\/)"+objx,'\\1'+objy,input[i])
        vim.current.range[i] = re.sub("label=(\"|')"+labx,'label=\\1'+laby,input[i])

except Exception, e:
    print e
EOF
endfunction

function! MakeGroups()
'<,'>python << EOF
try:
    import vim
    import notetab
    import re
    input = "\n".join(vim.current.range[:])

    #CLEAN UP THE TABS
    input = re.sub("\t+", " ", input)
    
    #CLEAN UP SPACES
    input = re.sub("\n +\n", "\n\n", input)
    
    #CLEAN UP THE EXTRA LINE BREAKS
    input = re.sub("\n{2,}", "\n", input)
    
    input = input.strip().split("\n")
    
    for x in range(0,len(input)):
        input[x] = re.sub("^[a-zA-Z0-9]{1,2}[\.:\)][ \t]+", "\n", input[x])
    for x in range(len(input)):
        vim.current.range[x] = "  <group label=\"g" + str(x+1) + "\">" + re.sub(r"^[a-zA-Z0-9]+(\.|:)|^[a-zA-Z0-9]+[a-zA-Z0-9]+(\.|:)", "", input[x]).strip() + "</group>"

except Exception, e:
    print e
EOF
endfunction

function! AddGroups()
'<,'>python << EOF
try:
    import vim
    import re
    input = vim.current.range[:]
    count = 1
    while "" in input:
        del input[input.index("")]
    for x in input:
        if "alt=" in x:
            x = x.replace(" alt=\"", " groups=\"g\" alt=\"")
            count += 1
        else:
            x = x.replace("\">", "\" groups=\"g\">")
            count += 1
        vim.current.range[count-2] = x
        
except Exception, e:
    print e
EOF
endfunction
