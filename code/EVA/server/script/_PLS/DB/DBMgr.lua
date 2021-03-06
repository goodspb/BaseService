DBMgr = {}


function DBMgr:Init()

    self.ConnPlayerInfo = MysqlConn.NewInstance();
    local conn_info = { "localhost", "root", "", "d_mt_player", 3306 };
    self.ConnPlayerInfo:Connect( conn_info );


    self.StmtGetPlayerInfo      = MysqlStmt.NewInstance("CALL _t_mt_select_playerinfo(?)");
    self.StmtCreatePlayer       = MysqlStmt.NewInstance("CALL _t_mt_insert_playerinfo(?)");
    
    
    self.MysqlResult = MysqlResult.NewInstance();
    
    
    
    self.ItemIDGen = IDGenerate.NewInstance(1020);
    
end

function DBMgr:LoadPlayerInfo(_uid)

    self.MysqlResult:Clear();
    self.StmtGetPlayerInfo:Clear();

	self.StmtGetPlayerInfo:SetUint64(_uid);
	
    if self.ConnPlayerInfo:Query( self.StmtGetPlayerInfo, self.MysqlResult ) > 0 then
        
        local tb_player_info    = PlayerDataHelper:new();
        
        tb_player_info.f_uid            = self.MysqlResult:GetUint64();
        tb_player_info.f_nickname       = self.MysqlResult:GetString();
        tb_player_info.f_portrait       = self.MysqlResult:GetUint32();
        tb_player_info.f_money          = self.MysqlResult:GetUint64();
        tb_player_info.f_rmb            = self.MysqlResult:GetUint64();
        tb_player_info.f_main           = self.MysqlResult:GetUint32();
        tb_player_info.f_flag_bit       = self.MysqlResult:GetUint64();

        return tb_player_info;
    end

    return nil;
end

function DBMgr:CreatePlayer(_uid)

    self.StmtCreatePlayer:Clear();
	self.StmtCreatePlayer:SetUint64(_uid);
	
    if self.ConnPlayerInfo:Exec( self.StmtCreatePlayer ) > 0 then
        return true;
    end

    return false;
end


--释放函数
function DBMgr:Release()
    
end


return DBMgr;
