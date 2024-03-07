WIEGPrinter = VolitionCabinetPrinter:New { Prefix = "WIEG", ApplyColor = true }

function WIEGPrint(...)
  WIEGPrinter:SetFontColor(0, 255, 255)
  WIEGPrinter:Print(...)
end

function WIEGTest(...)
  WIEGPrinter:SetFontColor(100, 200, 150)
  WIEGPrinter:PrintTest(...)
end

function WIEGDebug(...)
  WIEGPrinter:SetFontColor(200, 100, 50)
  WIEGPrinter:PrintDebug(...)
end

function WIEGWarn(...)
  WIEGPrinter:SetFontColor(200, 200, 0)
  WIEGPrinter:PrintWarning(...)
end

function WIEGDump(...)
  WIEGPrinter:SetFontColor(190, 150, 225)
  WIEGPrinter:Dump(...)
end

function WIEGDumpArray(...) WIEGPrinter:DumpArray(...) end
