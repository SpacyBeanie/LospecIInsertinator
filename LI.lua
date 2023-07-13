local MainThingies = script.Parent
local CHS = game:GetService("ChangeHistoryService")
local SEL = game:GetService("Selection")
local HTTP = game:GetService("HttpService")
local toolbar = plugin:CreateToolbar("Lospec Insertinator")
local newScriptButton = toolbar:CreateButton("Lospec Insertinator","Open the Lospec Insertinator UI","rbxassetid://14041163540")
local WidgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float,false,false,300,400,150,150)
local MainWidget = plugin:CreateDockWidgetPluginGui("Lospec Insertinator",WidgetInfo)
MainWidget.Title = "Lospec Insertinator"
local Menu = MainThingies:WaitForChild("Main")
Menu.Parent  = MainWidget
newScriptButton.Click:Connect(function()
	MainWidget.Enabled = not MainWidget.Enabled
end)

function Palette2BaseParts(Table)
	local Folder = Instance.new("Folder")
	Folder.Name = Table.name .. " - " .. Table.author
	for i,v:String in Table.colors do
		local NewPart = Instance.new("Part")
		NewPart.Size = Vector3.new(1,1,1)
		NewPart.CFrame = CFrame.new(0,NewPart.Size.Y * i, 0)
		NewPart.Color = Color3.fromHex(v)
		NewPart.Name = v
		NewPart.Parent = Folder
	end
	return Folder
end

function GatherPalette(PaletteName)

	local InitialURL = "https://Lospec.com/palette-list/"
	InitialURL ..= PaletteName..".json"
	print("Requesting...")
	local Attempt = HTTP:RequestAsync({
		Url = InitialURL,
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json"
		}
	} )
	if Attempt.Success then
		print("Request success! Inserting...")
		local EndResult = HTTP:JSONDecode(Attempt.Body)
		local PartsFolder = Palette2BaseParts(EndResult)
		PartsFolder.Parent = workspace
		SEL:Set({PartsFolder})
		
		print("Inserted! ("..PartsFolder:GetFullName()..")")
	else
		print("Request failed! ("..Attempt.StatusCode..")")
		print("Here is the response the website gave: \n"..Attempt.Body)
	end
end

Menu.MainMenu.InsertButton.MouseButton1Click:Connect(function()
	GatherPalette(Menu.MainMenu.SlugBox.Slug.Text)
end)